import sublime, sublime_plugin

def plugin_loaded():
    window = sublime.active_window()
     window.run_command("show_panel", {"panel": "console", "toggle": True})