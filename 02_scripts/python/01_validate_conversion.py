"""Validate a single IFLS export against Stata using Python.

Example:
  python 02_scripts/python/01_validate_conversion.py --wave ifls5 --book hh --dataset bk_ar1
"""
import argparse
from pathlib import Path
import pandas as pd
import pyarrow.parquet as pq
import pyreadstat

ROOT = Path(__file__).resolve().parents[2]


def validate(wave: str, book: str, dataset: str, root: Path = ROOT) -> dict:
    relative = Path(wave) / book / dataset
    source = root / "01_data/01_raw_dta" / relative.with_suffix(".dta")
    csv_path = root / "01_data/02_raw_csv" / relative.with_suffix(".csv")
    parquet_path = root / "01_data/03_raw_parquet" / relative.with_suffix(".parquet")
    meta_path = root / "01_data/03_metadata" / relative.parent / f"{dataset}_variables.csv"
    for path in (source, csv_path, parquet_path, meta_path):
        if not path.is_file():
            raise FileNotFoundError(path)

    original, _ = pyreadstat.read_dta(str(source), apply_value_formats=False)
    csv = pd.read_csv(csv_path)
    parquet = pd.read_parquet(parquet_path)
    metadata = pd.read_csv(meta_path)
    checks = {
        "csv_rows": len(csv) == len(original),
        "parquet_rows": len(parquet) == len(original),
        "csv_column_order": list(csv.columns) == list(original.columns),
        "parquet_column_order": list(parquet.columns) == list(original.columns),
        "metadata_column_order": list(metadata["variable"]) == list(original.columns),
    }
    for check, passed in checks.items():
        print(f"{'PASS' if passed else 'FAIL'} {check}")
    if not all(checks.values()):
        raise AssertionError("Conversion validation failed")
    return checks


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--wave", required=True)
    parser.add_argument("--book", default="hh")
    parser.add_argument("--dataset", required=True)
    args = parser.parse_args()
    validate(args.wave, args.book, args.dataset)
