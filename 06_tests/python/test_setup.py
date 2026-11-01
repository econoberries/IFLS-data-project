from pathlib import Path

def test_project_structure():
    root = Path(__file__).resolve().parents[2]
    assert (root / "IFLS_Data_Preparation.Rproj").is_file()
    assert (root / "02_scripts" / "R" / "00_setup_folders.R").is_file()
    assert (root / "02_scripts" / "python" / "00_setup.py").is_file()
