# Repository migration — 2026-10-18

This public repository is the independent Windows edition of **What's up my neighbor AI Input**.

- Original repository: https://github.com/yuipan0611/groq-ai-voice-input-macos (renamed in place to https://github.com/yuipan0611/whats-up-my-neighbor-ai-input-macos).
- Snapshot: `eceb1b508af83446431244741263d79e0903f911` on original `main`.
- Retained history: `windows/`, Windows CI, `LICENSE`, and `.gitignore`; `windows/` was promoted to the root. No macOS application code or signing secrets were imported.
- Tool: git-filter-repo `a40bce548d2c`. Authors and commit messages were retained; filtered commit IDs necessarily differ. See [commit map](migration-commit-map.txt); zero IDs mean commits without retained changes were removed.
- Historical beta: original source `b072d0a61d976a6765b3a6ce6eb47527b466c2f8` maps to `c1dda7ffa684de56afb12dba06d3f4bc214c710d`. Tag `windows-v0.1.0-beta.1` identifies that historical source, not the migration edits on `main`.
- The beta release assets are byte-for-byte copies of the original assets. Their manifest and validation evidence intentionally retain the original source SHA and CI run. Copying them is not a rebuild or a new acceptance test.
- Migration CI on `main` builds the relocated sources independently and uploads development artifacts. It does not replace the historical beta or publish a stable release.
- Historical CI, PR, and release evidence in `VALIDATION.md` continues to point to the original repository. GitHub redirects those URLs after its rename.
- AppId, executable name, Credential Manager target, settings, vocabulary paths, and installer upgrade identity are unchanged. Existing beta installers still contain their original publisher links.
- Real Windows 10/11 microphones, Bluetooth, Chinese IME, and third-party applications remain pending physical-device acceptance.

No feature parity with macOS is implied. Future development and releases happen independently here.


## 2026-11 從 whats-up-my-neighbor-ai-input-windows 拆分

來源為 `yuipan0611/whats-up-my-neighbor-ai-input-windows` main **`5a32eb77a50da33d3313a1c82495643ab286fb40`**（`5a32eb7`）。目的地為 `yuipan0611/whats-up-my-neighbor-voice-meeting-windows`。在全新 GitHub clone 執行 git-filter-repo **2.47.0**（`--version`: `a40bce548d2c`），只處理 main 的完整祖先歷史，沒有複製其他分支或 tag。原 repo 與現有 worktree 未修改。

### 保留與排除

保留的來源路徑如下；不存在於來源 HEAD 的 `docs/plans/` 也納入歷史篩選。

```text
Neighbor.Core/
Neighbor.Windows/
Neighbor.Tests/
Shared/UpdateDownloader.cs
Shared/UpdateDownloadChecks.cs
Shared/UpdateDownloadUiFixture.cs
windows-lite/NekoChat.Animation/
windows-lite/NekoChat.Animation.Tests/
assets/
packaging/
Examples/
tools/a11y-verification/
scripts/build.ps1
scripts/package.ps1
scripts/smoke-gate.ps1
scripts/test-install.ps1
docs/ARCHITECTURE.md
docs/DEVELOPMENT.md
docs/TESTING.md
docs/DESKTOP-PET.md
docs/UPDATES.md
docs/WINDOWS-IMPROVEMENTS.md
docs/WEBSITE.md
docs/plans/
docs/verification/WINDOWS-DIRECT-DOWNLOAD-20261031.md
MIGRATION.md
migration-commit-map.txt
README.md
LICENSE
PRIVACY.md
SECURITY.md
CONTRIBUTING.md
CHANGELOG.md
RELEASE_NOTES.md
VALIDATION.md
VERSION
THIRD-PARTY-NOTICES.txt
使用說明.txt
.gitignore
.gitattributes
.github/workflows/windows.yml
.github/workflows/release.yml

```

`windows-lite/NekoChat.Animation/`、`windows-lite/NekoChat.Animation.Tests/` 分別改名為根目錄 `NekoChat.Animation/`、`NekoChat.Animation.Tests/`。動畫原始碼、素材與授權獨立保留；`Neighbor.Windows`／`Neighbor.Tests` 的 project reference 隨之修正，Windows CI 另跑動畫 manifest／frame tests。

排除未列入的所有路徑，包含 `nekochat/`、其他 `windows-lite/`（Neko Chat Lite 留在原 repo）、Lite workflows/scripts、非必要 Shared fixtures、班級／附件／聊天文件、舊混合 `.codex` 設定。明確排除 `docs/verification/WINDOWS-UPGRADE-CLEANUP-20261031.md`（純 Lite 升級報告）及 `tools/ui3-native-probe/`（Lite 教室 QA 工具，無語音建置引用）。`tools/a11y-verification/` 是語音 HUD 驗證工具，保留。

本次 commit 對照表為 [migration-2026-11-commit-map.txt](migration-2026-11-commit-map.txt)，是兩次篩選組合後的原來源 SHA → 改寫 SHA（零值代表該提交不含保留範圍）。舊的 `migration-commit-map.txt` 與本文件先前章節仍是上一次 Mac → Windows 拆分的歷史紀錄，不套用到本次產物。

### 修正與不變項目

修正 commit 只處理拆分路徑、repo／更新來源連結、文件、CI、單筆掃描誤報與安全設定。Shared 更新下載器／fixtures 移除未編譯的 Lite namespace 分支，net48 的既有邏輯保留；仍保留舊混合 release metadata 的解析／拒絕測試。動畫重新匯出工具的根路徑隨搬移調整，移除只替 Lite 產生靜態外觀的步驟。建置腳本原已只建語音工具，未改流程。`release.yml` 只由 `workflow_dispatch` 手動觸發；本次不執行發布流程。

`DictationCoordinator.cs`、`GroqTranscriber.cs`、`WasapiRecorder.cs`、`VERSION` 保持來源逐字相同。AppId、`Neighbor.exe`、`NekoChat.Animation.dll`、Credential Manager target `WhatsUpMyNeighbor/GroqApiKey`、安裝位置與升級／解除安裝／登入啟動識別全部維持不變；僅更新下載的 repo 所有權移到新 repo。不打 tag、不發 release，不把歷史驗收等同新產物已驗收。

### 安全檢查

先使用 gitleaks **8.30.1** 掃描完整改寫歷史：

```sh
gitleaks git . --log-opts='--all --full-history' --redact=100 --ignore-gitleaks-allow --report-format json --report-path ../gitleaks-final.json --no-banner --no-color
```

第一次命中 **1 筆** generic-api-key：`Neighbor.Tests/RecordingHudAccessibilityTests.cs:187` 的 `IidAccessible` 常數。值為 `618736E0-3C3D-11CF-810C-00AA00389B71`，與 [Microsoft 公開 IAccessible COM Guid](https://learn.microsoft.com/en-us/dotnet/api/accessibility.iaccessible?view=windowsdesktop-10.0) 相同。PM Emily 唯讀核對後判定為誤報；不改歷史或程式碼，`.gitleaksignore` **只列該 commit／檔案／規則／行號的單筆 fingerprint**，不排除整個檔案或 GUID 規則。初始遮蔽報告保留在 clone 外，不 commit。加上此筆記錄後必須重跑完整歷史且 exit 0，並完成全歷史 >5 MB blobs、音檔及私有資料盤點，才能公開推送。任何額外命中必須停止回報。

推送僅允許用精確 `--force-with-lease=refs/heads/main:177486b8eba730913f39ede92001c9913404f766` 覆蓋新 repo 已核對的單一 README＋LICENSE 初始 commit；若遠端改變則停止，不改 lease、不覆蓋其他提交。

靜態盤點覆蓋篩選後全部 71 個祖先提交、3,135 個歷史 blob：>5,000,000 bytes 檔案 0、音訊／影片副檔名 0、私有名單／逐字稿／憑證檔名 0。文字個資模式的 7 處 email 命中都在公開的 `.NET` 第三方授權聲明內，是授權／作者聯絡資訊，依法保留；沒有識別到私人會議內容或班級個資。Git 作者 metadata 與原有公開署名仍保留。自動模式盤點有侷限，不能保證識別任意形式的個資。
