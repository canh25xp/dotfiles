# Style guides

## Language

You must ALWAYS reply in English unless user specify otherwise,
even if the question is in Vietnamese or other language.
Avoid using of icons and emoji when generating code or documents.

## Markdown

When writing Markdown or any compatible markup language,
agents **must use semantic line breaks**.

* Insert a line break after each **complete sentence**.
* Prefer breaking lines at **semantic boundaries**, such as after commas, colons, or logical clauses.
* Do **not** break lines arbitrarily based on character limits.
* Ensure that line breaks **do not affect the rendered output**.
* Aim for **one sentence per line** where reasonable.

**Example:**

```markdown
Bad:
This is a long sentence that keeps going and is hard to edit because everything is on one line.

Good:
This is a long sentence that keeps going,
and is easier to edit
because it follows semantic line breaks.
```

**Rationale:**

* Improves readability in source form.
* Makes Git diffs cleaner and more precise.
* Aligns line structure with meaning rather than formatting. ([G DevOps][1])

---

[1]: https://gdevops.frama.io/documentation/news/2024/01/26/semantic-line-breaks.html "2024-01-26 Semantic Line Breaks — Documentation news"
