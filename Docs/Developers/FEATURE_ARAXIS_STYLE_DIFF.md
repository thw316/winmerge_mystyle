# Feature Specification & Implementation: Araxis-Style Diff View & Single-Line Diff Panel

## 1. Overview & Requirements

This feature branch introduces two major enhancements to WinMerge's comparison and visualization engine, modeled after Araxis Merge's diff presentation:

1. **Araxis-Style Block Line Pairing in Diff View (`OPT_CMP_BLOCK_LINE_PAIRED`)**:
   - Instead of clumping all real lines at the top of a changed block and padding all ghost lines at the bottom, diff blocks are now decomposed with 1:1 consecutive line pairing.
   - For any modified block with $M$ lines on the left and $N$ lines on the right, lines $0 \dots \min(M, N)-1$ are directly paired and aligned horizontally side-by-side.
   - Remaining unmatched lines appear as clean insertion/deletion ghost blocks immediately adjacent to the paired lines.

2. **Single-Line No-Wrap Line Diff Panel (Line-to-Line Comparison)**:
   - The docking Diff Pane (`CDiffViewBar`, `CMergeEditSplitterView` with `m_bDetailView = true`) is updated to display strictly **ONE line** at a time.
   - **Word Wrap Disabled**: Word wrapping is permanently disabled on detail view panes so long lines stay on a single horizontal row with horizontal scroll support.
   - **Line Number to Line Number**: Selection margin line numbers are explicitly enabled for both panes, showing the active line number on the left vs the corresponding line number on the right.
   - **Real-time Caret Synchronization**: When the caret moves anywhere in the main comparison view, the Line Diff Panel dynamically syncs to display that exact line and its paired counterpart with character-level diff highlighting.
   - **Compact Sleek Height**: The bottom Diff Pane defaults to a compact single-row height (~52px), creating a focused line-over-line inspection view.

---

## 2. Code Changes Summary

| File | Changes Made |
| :--- | :--- |
| `Src/OptionsDef.h` | Added `OPT_CMP_BLOCK_LINE_PAIRED` (`"Settings/BlockLinePaired"`). |
| `Src/OptionsInit.cpp` | Initialized `OPT_CMP_BLOCK_LINE_PAIRED` to `true` by default. |
| `Src/MergeDoc.cpp` | Enabled `AdjustDiffBlocks()` in `CMergeDoc::Rescan()` when `OPT_CMP_BLOCK_LINE_PAIRED` is active. |
| `Src/MergeDocDiffSync.cpp` | Implemented Araxis-style consecutive line pairing in `CMergeDoc::AdjustDiffBlock()` and corrected `diffMap` sub-block offset indexing. |
| `Src/MergeEditView.h` | Declared `OnDisplayDiffLine(int nLine)` and overridden `DrawMargin(const CRect&, int, int)`. |
| `Src/MergeEditView.cpp` | Restricted `OnDisplayDiff` to single-line for detail view; implemented `OnDisplayDiffLine`; hooked caret synchronization in `OnUpdateCaret`; enforced no-wrap and line numbers in `SetWordWrapping`, `LoadOptions`, `DocumentsLoaded`; suppressed non-target line numbers in `DrawMargin`. |
| `Src/MergeEditSplitterView.cpp` | Omitted `WS_VSCROLL` for detail view; configured detail view panes to disable vertical scrollbars and word wrapping. |
| `Src/DiffViewBar.cpp` | Configured default docked height (`m_szHorz = CSize(200, 52)`) for a sleek single-line panel. |

---

## 3. How to Build & Test

1. Prerequisites:
   - Microsoft Visual Studio 2022 (with Desktop C++, MFC, and ATL components).
   - 7-Zip in `PATH`.
2. Run dependency download:
   ```cmd
   DownloadDeps.cmd
   ```
3. Build the solution:
   ```cmd
   BuildBin.vs2022.cmd x64
   ```
4. Run the executable:
   ```cmd
   Build\x64\Release\WinMergeU.exe
   ```
