import json
import re
import shutil
import subprocess
import time
import zipfile
from pathlib import Path
from urllib.parse import urlparse

import requests


ROOT = Path("/Users/all/Documents/dev/soft_light/research/soft_light_competitors_20260317")
ROUND2_ROOT = ROOT / "第二轮补充分析"
APK_ROOT = ROUND2_ROOT / "apks"
EXTRACT_ROOT = APK_ROOT / "extracted"
ADB = "/Users/all/Library/Android/sdk/platform-tools/adb"
UA = "Mozilla/5.0"

APPS = [
    {
        "package": "com.display.light.TableLamp",
        "page": "https://apkcombo.com/screen-light-night-reading/com.display.light.TableLamp/",
    },
    {
        "package": "com.studio360apps.screen.flashlight",
        "page": "https://apkcombo.com/screen-flashlight-night-lamp/com.studio360apps.screen.flashlight/",
    },
    {
        "package": "com.ryosakata.reading_light",
        "page": "https://apkcombo.com/reading-light/com.ryosakata.reading_light/",
    },
]


def run(cmd, check=True, capture=True):
    return subprocess.run(
        cmd,
        check=check,
        text=True,
        capture_output=capture,
    )


def adb(*args, check=True):
    return run([ADB, *args], check=check)


def get_html(url):
    return requests.get(url, headers={"User-Agent": UA}, timeout=30).text


def get_metadata(page_url):
    html = get_html(page_url)
    data = {}
    for match in re.findall(
        r'<script type="application/ld\+json">(.*?)</script>',
        html,
        flags=re.S,
    ):
        try:
            parsed = json.loads(match)
        except json.JSONDecodeError:
            continue
        if isinstance(parsed, dict) and parsed.get("@type") == "SoftwareApplication":
            data = {
                "name": parsed.get("name"),
                "category": parsed.get("applicationSubCategory"),
                "description": parsed.get("description"),
                "rating": (parsed.get("aggregateRating") or {}).get("ratingValue"),
                "reviews": (parsed.get("aggregateRating") or {}).get("reviewCount"),
                "offers": parsed.get("offers"),
            }
            break
    return data


def get_download_link(page_url, package_name):
    dl_page = get_html(page_url.rstrip("/") + "/download/apk")
    xid = re.search(r'var xid = "([^"]+)"', dl_page)
    if not xid:
        raise RuntimeError(f"xid not found for {package_name}")
    post_url = page_url.rstrip("/") + f"/{xid.group(1)}/dl"
    resp = requests.post(
        post_url,
        headers={"User-Agent": UA},
        data={"package_name": package_name, "version": ""},
        timeout=30,
    )
    resp.raise_for_status()
    match = re.search(r'href="(https://apkcombo\.com/d\?u=[^"]+)"', resp.text)
    if not match:
        raise RuntimeError(f"download href not found for {package_name}")
    return match.group(1)


def download_file(url, package_name):
    APK_ROOT.mkdir(parents=True, exist_ok=True)
    with requests.get(url, headers={"User-Agent": UA}, timeout=60, stream=True) as resp:
        resp.raise_for_status()
        parsed = urlparse(resp.url)
        final_name = Path(parsed.path).name or f"{package_name}.bin"
        out = APK_ROOT / final_name
        with out.open("wb") as fh:
            for chunk in resp.iter_content(1024 * 128):
                if chunk:
                    fh.write(chunk)
    return out


def choose_install_files(downloaded):
    suffix = downloaded.suffix.lower()
    if suffix == ".apk":
        return [downloaded]

    extract_dir = EXTRACT_ROOT / downloaded.stem
    if extract_dir.exists():
        shutil.rmtree(extract_dir)
    extract_dir.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(downloaded) as zf:
        zf.extractall(extract_dir)

    apks = sorted(extract_dir.glob("*.apk"))
    if not apks:
        raise RuntimeError(f"no apk found inside {downloaded}")

    base = None
    for apk in apks:
        if apk.name == f"{downloaded.stem}.apk" or "config." not in apk.name:
            base = apk
            break
    if base is None:
        base = apks[0]

    selected = [base]

    for pattern in ["*arm64*.apk", "*universal*.apk"]:
        hit = next((p for p in apks if p not in selected and p.match(pattern)), None)
        if hit:
            selected.append(hit)
            break

    for pattern in ["*xxxhdpi*.apk", "*xxhdpi*.apk", "*xhdpi*.apk", "*mdpi*.apk", "*hdpi*.apk"]:
        hit = next((p for p in apks if p not in selected and p.match(pattern)), None)
        if hit:
            selected.append(hit)
            break

    for pattern in ["*en*.apk", "*lang_en*.apk"]:
        hit = next((p for p in apks if p not in selected and p.match(pattern)), None)
        if hit:
            selected.append(hit)
            break

    return selected


def install_package(package_name, apk_files):
    adb("uninstall", package_name, check=False)
    if len(apk_files) == 1:
        adb("install", "-r", str(apk_files[0]))
    else:
        adb("install-multiple", "-r", *[str(p) for p in apk_files])


def resolve_activity(package_name):
    out = adb("shell", "cmd", "package", "resolve-activity", "--brief", package_name).stdout
    lines = [line.strip() for line in out.splitlines() if line.strip()]
    for line in reversed(lines):
        if "/" in line and "No activity" not in line:
            return line
    return None


def launch_package(package_name):
    activity = resolve_activity(package_name)
    if activity:
        adb("shell", "am", "start", "-n", activity, check=False)
    else:
        adb(
            "shell",
            "monkey",
            "-p",
            package_name,
            "-c",
            "android.intent.category.LAUNCHER",
            "1",
            check=False,
        )
    time.sleep(4)


def capture(package_name):
    app_dir = ROUND2_ROOT / package_name
    shot_dir = app_dir / "screenshots"
    ui_dir = app_dir / "ui_dumps"
    shot_dir.mkdir(parents=True, exist_ok=True)
    ui_dir.mkdir(parents=True, exist_ok=True)

    shot = shot_dir / "shot_001.png"
    with shot.open("wb") as fh:
        subprocess.run([ADB, "exec-out", "screencap", "-p"], check=True, stdout=fh)

    remote = f"/sdcard/{package_name.replace('.', '_')}_ui.xml"
    adb("shell", "uiautomator", "dump", remote, check=False)
    adb("pull", remote, str(ui_dir / "ui_001.xml"), check=False)
    adb("shell", "rm", remote, check=False)

    return {"screenshot": str(shot), "ui_dump": str(ui_dir / "ui_001.xml")}


def main():
    ROUND2_ROOT.mkdir(parents=True, exist_ok=True)
    results = []
    for app in APPS:
        pkg = app["package"]
        result = {"package": pkg, "page": app["page"]}
        try:
            result["metadata"] = get_metadata(app["page"])
            link = get_download_link(app["page"], pkg)
            result["download_link"] = link
            downloaded = download_file(link, pkg)
            result["downloaded_file"] = str(downloaded)
            install_files = choose_install_files(downloaded)
            result["install_files"] = [str(p) for p in install_files]
            install_package(pkg, install_files)
            launch_package(pkg)
            result["capture"] = capture(pkg)
            result["status"] = "ok"
        except Exception as exc:  # noqa: BLE001
            result["status"] = "error"
            result["error"] = str(exc)
        results.append(result)

    (ROUND2_ROOT / "round2_results.json").write_text(
        json.dumps(results, ensure_ascii=False, indent=2)
    )
    print(json.dumps(results, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
