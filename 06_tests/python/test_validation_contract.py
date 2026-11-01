"""Synthetic structural tests: no IFLS respondent data required."""
from pathlib import Path
import ast

ROOT = Path(__file__).resolve().parents[2]


def test_python_validation_script_is_syntactically_valid():
    path = ROOT / "02_scripts/python/01_validate_conversion.py"
    ast.parse(path.read_text(encoding="utf-8"))


def test_validation_contract_has_no_hardcoded_local_home_path():
    path = ROOT / "02_scripts/python/01_validate_conversion.py"
    assert "/Users/" not in path.read_text(encoding="utf-8")
