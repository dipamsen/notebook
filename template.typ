#import "@preview/cetz:0.3.2"

#let output-format = sys.inputs.at("fmt")

#let theme = state("light")
#let div-frame(content, attrs: (:)) = html.elem("div", html.frame(content), attrs: attrs)
#let span-frame(content, attrs: (:)) = html.elem("span", html.frame(content), attrs: attrs)

#let boxed(body) = context block(
  stroke: if output-format == "html" and theme.get() == "dark" { white } else { black },
  inset: 1em,
  body,
)

#let canvas(body, ..args) = context {
  if target() == "html" {
    (
      div-frame(
        {
          set text(fill: white)
          cetz.canvas(
            {
              cetz.draw.set-style(stroke: (paint: white))
            }
              + body,
            ..args,
          )
        },
        attrs: ("class": "dark"),
      )
        + div-frame(cetz.canvas(body, ..args), attrs: ("class": "light"))
    )
  } else {
    cetz.canvas(
      {
        cetz.draw.set-style(stroke: (paint: if theme.get() == "dark" { white } else { black }))
      }
        + body,
      ..args,
    )
  }
}


#let polyfill-html(block: true, class: "") = it => context {
  let frame = if block { div-frame } else { span-frame }
  let class = class + if block { " frame-block" } else { " frame-inline" }
  if target() == "html" {
    {
      theme.update("dark")
      set text(fill: white)
      frame(attrs: ("class": "dark " + class), it)
    }
    {
      theme.update("light")
      frame(attrs: ("class": "light " + class), it)
    }
  } else {
    it
  }
}



#let numbered(body) = {
  set math.equation(numbering: "(1)")
  body
}


#let make-title(body, date) = context {
  if target() == "paged" {
    block(text(body, size: 2.2em, weight: 700))
    block(text(date.display("[month repr:long] [day], [year]"), size: 1em))
    v(1em)
  } else {
    html.elem("h1", body)
    html.elem("div", attrs: ("class": "date"), date.display("[month repr:long] [day], [year]"))
  }
}

#let header() = context {
  if target() == "paged" {
    [Dipam's Notebook]
  } else {
    html.elem(
      "div",
      attrs: ("class": "declare"),
      html.elem("a", [Dipam's Notebook], attrs: ("href": "../"))
        + html.elem(
          "input",
          attrs: (
            "type": "checkbox",
            "id": "theme-switch",
            "class": "theme-switch",
            "checked": "true",
            "onclick": ```javascript
            let theme = document.body.parentElement.getAttribute("data-theme");
            if (theme === "dark") {
              document.body.parentElement.setAttribute("data-theme", "light");
            } else {
              document.body.parentElement.setAttribute("data-theme", "dark");
            }
            localStorage.setItem("dsnb-theme", document.body.parentElement.getAttribute("data-theme"));
            ```.text,
          ),
        )
        + html.elem("label", attrs: ("for": "theme-switch", "class": "theme-switch-label")),
    )
  }
}

#let footer() = context {
  if target() == "html" {
    html.elem(
      "footer",
      html.elem(
        "div",
        attrs: ("class": "contain"),
        {
          html.elem(
            "div",
            attrs: ("class": "right"),
            html.elem(
              "div",
              html.elem(
                "a",
                html.elem(
                  "img",
                  attrs: ("src": "../assets/github-mark.svg", "alt": "github", "width": "30", "class": "light"),
                ),
                attrs: ("href": "https://github.com/dipamsen"),
              )
                + html.elem(
                  "a",
                  html.elem(
                    "img",
                    attrs: ("src": "../assets/github-mark-white.svg", "alt": "github", "width": "30", "class": "dark"),
                  ),
                  attrs: ("href": "https://github.com/dipamsen"),
                ),
            )
              + html.elem("pre", "@dipamsen"),
          )
          html.elem("div", attrs: ("class": "left"), "stuff about programming, math and more")
        },
      ),
    )
  }
}

#let blog-post(title: "", date: datetime.today(), body) = {
  set enum(tight: false)
  set text(1.2em, hyphenate: false, region: "uk")
  set par(justify: true)

  set text(font: "Figtree")

  set page(
    footer: context [
      #set text(1.2em)
      #h(1fr)#counter(page).get().first()#h(1fr)
    ],
    header: context [
      #set text(luma(100))
      #link("https://dipamsen.github.io/notebook")[Dipam's Notebook]
      #h(1fr)
      #title
    ],
  ) if output-format == "pdf"

  show math.equation.where(block: true): polyfill-html(class: "block-math")

  show math.equation.where(block: false): polyfill-html(class: "inline-math", block: false)

  show grid: polyfill-html(class: "grid")

  show block: polyfill-html(class: "box")

  if output-format == "html" {
    html.elem(
      "html",
      attrs: ("lang": "en", "data-theme": "dark"),
      html.elem(
        "head",
        {
          html.elem("meta", attrs: ("charset": "UTF-8"))
          html.elem("meta", attrs: ("name": "viewport", "content": "width=device-width, initial-scale=1"))
          html.elem("title", title + " | Dipam's Notebook")
          html.elem("link", attrs: ("rel": "stylesheet", "href": "style-post.css"))
          html.elem("link", attrs: ("rel": "preconnect", "href": "https://fonts.googleapis.com"))
          html.elem("link", attrs: ("rel": "preconnect", "href": "https://fonts.gstatic.com", "crossorigin": ""))
          html.elem(
            "link",
            attrs: (
              "href": "https://fonts.googleapis.com/css2?family=Azeret+Mono:ital,wght@0,100..900;1,100..900&family=Figtree:ital,wght@0,300..900;1,300..900&family=Source+Code+Pro:ital,wght@0,200..900;1,200..900&display=swap",
              "rel": "stylesheet",
            ),
          )
          html.elem(
            "script",
            ```js
            document.addEventListener("DOMContentLoaded", () => {
              const lskey = "dsnb-theme";
              const theme = localStorage.getItem(lskey);
              if (theme) {
                document.body.parentElement.setAttribute("data-theme", theme);
              } else {
                document.body.parentElement.setAttribute("data-theme", "dark");
              }
              const themeSwitch = document.getElementById("theme-switch");
              themeSwitch.checked = document.body.parentElement.getAttribute("data-theme") === "dark";
            });
            ```.text,
          )
        },
      )
        + html.elem(
          "body",
          html.elem(
            "main",
            {
              header()
              html.elem(
                "div",
                [
                  #make-title(title, date)
                  #body
                ],
                attrs: ("class": "content"),
              )
            },
            attrs: ("class": "container"),
          )
            + footer(),
        ),
    )
  }

  if output-format == "pdf" {
    make-title(title, date)
    body
  }
}

