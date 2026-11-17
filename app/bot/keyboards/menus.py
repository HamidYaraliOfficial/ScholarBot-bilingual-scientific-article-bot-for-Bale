"""Reply / inline keyboards in the structures documented by the Bale Bot API."""
from __future__ import annotations

from app.core.localization import t
from app.providers.base import ArticleMeta

MENU_KEYS = [["btn_search", "btn_doi"], ["btn_link", "btn_author"], ["btn_recent", "btn_saved"],
             ["btn_help", "btn_settings"], ["btn_language"]]


def main_menu(lang: str) -> dict:
    return {"keyboard": [[{"text": t(lang, k)} for k in row] for row in MENU_KEYS]}


def language_picker() -> dict:
    return {"inline_keyboard": [[{"text": "🇮🇷 فارسی", "callback_data": "lang:fa"},
                                 {"text": "🇬🇧 English", "callback_data": "lang:en"}]]}


def _short(text: str, n: int = 48) -> str:
    text = " ".join((text or "").split())
    return text if len(text) <= n else text[: n - 1] + "…"


def candidates_keyboard(job_id: int, metas: list[ArticleMeta]) -> dict:
    rows = []
    for i, m in enumerate(metas):
        label = f"{i + 1}. {_short(m.title)}" + (f" ({m.year})" if m.year else "")
        rows.append([{"text": label, "callback_data": f"pick:{job_id}:{i}"}])
    return {"inline_keyboard": rows}


def article_actions(lang: str, article_id: int, bookmarked: bool, url: str | None) -> dict:
    row = [{"text": t(lang, "btn_unbookmark" if bookmarked else "btn_bookmark"), "callback_data": f"bm:{article_id}"}]
    rows = [row]
    if url and url.startswith(("http://", "https://")):
        rows.append([{"text": t(lang, "btn_official_page"), "url": url}])
    return {"inline_keyboard": rows}


def article_list(items: list[tuple[int, str]]) -> dict:
    return {"inline_keyboard": [[{"text": f"{i + 1}. {_short(title)}", "callback_data": f"re:{aid}"}]
                                for i, (aid, title) in enumerate(items)]}


def settings_keyboard(lang: str) -> dict:
    return language_picker()
