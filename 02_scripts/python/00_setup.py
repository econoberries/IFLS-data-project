"""Create local IFLS directories from the repository root; never overwrite data."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
FOLDERS = [
    "01_data/01_raw_dta", "01_data/02_raw_csv", "01_data/03_metadata", "01_data/03_raw_parquet",
    "01_data/04_cleaned", "01_data/05_harmonized", "01_data/06_panel",
    "01_data/07_research_ready", "05_outputs/tables",
    "05_outputs/figures", "05_outputs/quality_reports",
]

def main() -> None:
    for folder in FOLDERS:
        (ROOT / folder).mkdir(parents=True, exist_ok=True)
    print(f"Local IFLS directories ready: {ROOT}")

if __name__ == "__main__":
    main()
