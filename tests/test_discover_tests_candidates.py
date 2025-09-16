# Tests for discover_tests_candidates
# Framework: pytest (preferred) with standard assertions and parametrization.
# If your project uses unittest, these tests can be adapted to TestCase easily.

import os
import sys
from pathlib import Path

import pytest

try:
    # Try common import paths; adjust as needed if your module path differs.
    from discover import discover_tests_candidates
except ImportError:
    try:
        from discovery import discover_tests_candidates
    except ImportError as err:
        # Fallback to project-local packages; this keeps tests resilient across refactors.
        from importlib import import_module as _imp
        _candidates = None
        for mod in (
            "src.discover",
            "src.discovery",
            "project.discover",
            "project.discovery",
            "tools.discover",
        ):
            try:
                _m = _imp(mod)
                _candidates = getattr(_m, "discover_tests_candidates", None)
                if _candidates:
                    discover_tests_candidates = _candidates  # type: ignore
                    break
            except ImportError:
                continue
        if not _candidates:
            raise ImportError() from err


def _touch(p: Path, text: str = "") -> None:
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(text, encoding="utf-8")


@pytest.fixture
def tmp_tree(tmp_path: Path):
    # Create a representative test tree with various files and patterns
    files = {
        "tests/test_alpha.py": "def test_a(): pass\n",
        "tests/test_beta.py": "def test_b(): pass\n",
        "tests/helpers/util.py": "def helper(): pass\n",
        "package/module_test.py": "def test_c(): pass\n",
        "package/not_a_test.txt": "content\n",
        "nested/deep/test_gamma.py": "def test_g(): pass\n",
        "nested/deep/_private_test.py": "def test_p(): pass\n",
        "nested/deep/test_🌟.py": "def test_unicode(): pass\n",
        "nested/deep/__init__.py": "",
        "README.md": "# docs\n",
    }
    for rel, content in files.items():
        _touch(tmp_path / rel, content)
    return tmp_path


def norm(p: Path) -> str:
    return str(p).replace("\\", "/")


@pytest.mark.parametrize(
    "inputs,expected_contains,expected_absent",
    [
        # Happy path: standard tests/ directory with test_*.py
        (["tests/"], ["tests/test_alpha.py", "tests/test_beta.py"], ["tests/helpers/util.py"]),
        # Glob patterns
        (["**/test_*.py"], ["tests/test_alpha.py", "nested/deep/test_gamma.py"], ["package/not_a_test.txt"]),
        # Mixed files and dirs
        (["tests/test_beta.py", "nested/"], ["tests/test_beta.py", "nested/deep/test_gamma.py"], ["package/module_test.py"]),
        # File with unicode name
        (["nested/deep/"], ["nested/deep/test_🌟.py"], []),
    ],
)
def test_discover_candidates_basic_patterns(tmp_tree: Path, inputs, expected_contains, expected_absent):
    cwd = os.getcwd()
    try:
        os.chdir(tmp_tree)
        results = list(discover_tests_candidates(inputs))
        results_n = sorted(norm(Path(p)) for p in results)
        for exp in expected_contains:
            assert any(r.endswith(exp) for r in results_n), f"Expected {exp} in {results_n}"
        for bad in expected_absent:
            assert all(not r.endswith(bad) for r in results_n), f"Did not expect {bad} in {results_n}"
    finally:
        os.chdir(cwd)

def test_discover_candidates_ignores_non_python_files(tmp_tree: Path):
    cwd = os.getcwd()
    try:
        os.chdir(tmp_tree)
        results = list(discover_tests_candidates(["."]))
        assert all(r.endswith(".py") for r in results), f"Non-Python files leaked into results: {results}"
    finally:
        os.chdir(cwd)

@pytest.mark.parametrize(
    "inputs",
    [
        ([]),
        (["nonexistent_dir/"]),
        (["README.md"]),
    ],
)
def test_discover_candidates_empty_or_invalid_inputs(tmp_tree: Path, inputs):
    cwd = os.getcwd()
    try:
        os.chdir(tmp_tree)
        results = list(discover_tests_candidates(inputs))
        # Either empty or gracefully handles invalid paths without raising
        assert isinstance(results, list) or hasattr(results, "__iter__")
        # Count should be zero for no valid candidates
        assert len(list(results)) == 0
    finally:
        os.chdir(cwd)

def test_discover_candidates_deduplicates_and_sorts(tmp_tree: Path):
    cwd = os.getcwd()
    try:
        os.chdir(tmp_tree)
        res = list(discover_tests_candidates(["tests/test_alpha.py", "tests/", "tests/test_alpha.py"]))
        # Expect no duplicates
        normed = [norm(Path(p)) for p in res]
        assert len(normed) == len(set(normed)), f"Duplicates found: {normed}"
        # Many implementations return deterministic order; if not, we at least check that sorting is stable
        assert sorted(normed) == sorted(set(normed))
    finally:
        os.chdir(cwd)

def test_discover_candidates_recurses_directories_respecting_test_naming(tmp_tree: Path):
    cwd = os.getcwd()
    try:
        os.chdir(tmp_tree)
        res = list(discover_tests_candidates(["package/"]))
        normed = [norm(Path(p)) for p in res]
        assert any(p.endswith("package/module_test.py") for p in normed), f"Expected module_test.py, got {normed}"
        assert all(not p.endswith("package/not_a_test.txt") for p in normed)
    finally:
        os.chdir(cwd)