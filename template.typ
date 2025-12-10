#import "@preview/cetz:0.4.0"
#import "@preview/zebraw:0.6.1": zebraw-init
#import "@preview/fletcher:0.5.8"

#let output-format = sys.inputs.at("fmt")

#let div-frame(content, attrs: (:)) = html.elem("div", html.frame(content), attrs: attrs)
#let span-frame(content, attrs: (:)) = html.elem("span", html.frame(content), attrs: attrs)

#let boxed(body) = context block(
  stroke: if output-format == "html" { white } else { black },
  inset: 1em,
  body,
)

#let canvas(body, ..args) = context {
  if target() == "html" {
    div-frame(
      {
        set text(white)
        cetz.canvas(
          {
            cetz.draw.set-style(stroke: (paint: white))
          }
            + body,
          ..args,
        )
      },
      attrs: ("class": "frame-block"),
    )
  } else {
    cetz.canvas(
      {
        cetz.draw.set-style(stroke: (paint: black))
      }
        + body,
      ..args,
    )
  }
}

#let stroke-with(stroke, paint) = {
  if type(stroke) == std.stroke {} else if stroke != none {
    stroke = std.stroke(stroke)
  } else {
    stroke = std.stroke()
  }
  std.stroke(
    paint: paint, //if stroke.paint == auto { paint } else { stroke.paint },
    thickness: stroke.thickness,
    dash: stroke.dash,
    cap: stroke.cap,
    join: stroke.join,
    miter-limit: stroke.miter-limit,
  )
}

#let diagram(recolor: true, ..args) = context {
  // wrapper around fletcher.diagram
  if target() == "html" {
    div-frame(
      {
        set text(fill: white) if recolor
        let node-stroke = args.at("node-stroke", default: none)
        let edge-stroke = args.at("edge-stroke", default: none)
        let d = (
          node-stroke: if node-stroke == none { white + 0pt } else { stroke-with(node-stroke, white) },
          edge-stroke: stroke-with(edge-stroke, white),
        )
        if recolor {
          fletcher.diagram(
            ..args,
            ..d,
          )
        } else {
          fletcher.diagram(
            ..args,
          )
        }
      },
      attrs: ("class": "frame-block"),
    )
  } else {
    fletcher.diagram(
      ..args,
    )
  }
}

#let polyfill-html(block: true, class: "", fix-color: true) = it => context {
  let frame = if block { div-frame } else { span-frame }
  let class = class + if block { " frame-block" } else { " frame-inline" }
  if target() == "html" {
    set text(fill: white) if fix-color
    frame(attrs: ("class": class), it)
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
      html.elem("a", [Dipam's Notebook], attrs: ("href": "../")),
    )
  }
}

#let footer() = context {
  if target() == "html" {
    let innerHTML = ```html
      <div class="contain">
        <a href="https://github.com/dipamsen">
          <span>
            @dipamsen
            <svg class="github-icon" viewBox="0 0 24 24" fill="currentColor">
              <path
                d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"
              />
            </svg>
          </span>
        </a>
        <p style="color: #545454; margin: 0">
          stuff about programming, math and more
        </p></span>
      </div>
    ```.text
    html.elem(
      "footer",
      attrs: ("id": "footer"),
    )
    html.elem(
      "script",
      "document.getElementById('footer').innerHTML = `" + innerHTML + "`",
    )
  }
}

#let custom-css(body, raw-style) = context {
  if target() == "html" {
    let classname = "css-" + str(counter("mycss").get().first())
    counter("mycss").step()
    let css = "." + classname + " {\n" + raw-style + "\n}\n"
    html.elem("div", body + html.elem("style", css), attrs: ("class": classname))
  } else {
    body
  }
}

#let hscroll(body) = context {
  if target() == "html" {
    html.elem("div", body, attrs: ("class": "scroll-x"))
  } else {
    body
  }
}

#let blog-post(title: "", date: datetime.today(), body) = {
  set enum(tight: false)
  set text(1em, hyphenate: false, region: "uk")
  set par(justify: true)

  set text(font: "Figtree")

  set page(
    footer: context [
      #set text(1.2em)
      #h(1fr)#counter(page).get().first()#h(1fr)
    ],
    header: context [
      #set text(luma(100))
      #link("https://dipamsen.github.io/notebook")[Dipam\'s Notebook]
      #h(1fr)
      #title
    ],
  ) if output-format == "pdf"

  show math.equation.where(block: true): polyfill-html(class: "block-math")

  show math.equation.where(block: false): polyfill-html(class: "inline-math", block: false)

  show align: it => context {
    if target() == "html" {
      let align = it.at("alignment").x // left, center, right, auto
      let align-class = if align == center { "center" } else if align == right { "right" } else { "left" }

      html.elem("div", it, attrs: (
        "class": "align-" + align-class,
      ))
    } else {
      it
    }
  }

  // show grid: polyfill-html(class: "grid")

  // show grid

  // show block: polyfill-html(class: "box")

  //show raw.where(block: true): zebraw
  //
  show table: it => context {
    if target() == "html" {
      let column-gutter = it.fields().at("column-gutter") // list
      let row-gutter = it.fields().at("row-gutter") // list
      let align = it.fields().at("align") // left, center, right, auto
      let align-class = if align == center { "center" } else if align == right { "right" } else { "left" }

      let clm = str(column-gutter.at(0, default: 0pt + 0%).length.to-absolute().pt())
      let row = str(row-gutter.at(0, default: 0pt + 0%).length.to-absolute().pt())

      custom-css(
        html.elem("div", it, attrs: (
          "class": "table-align-" + align-class,
        )),
        "& table {
        border-spacing: " + clm + "px " + row + "px;
      ",
      )
    } else {
      it
    }
  }

  // show: zebraw-init

  show figure.caption: text.with(0.9em, fill: rgb("#545454"))

  show footnote: it => {
    if output-format == "html" {} else {
      it
    }
  }

  if output-format == "html" {
    html.elem(
      "html",
      attrs: ("lang": "en"),
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
              "href": "https://fonts.googleapis.com/css2?family=Azeret+Mono:ital,wght@0,100..900;1,100..900&family=Open+Sans:wght@300..700&family=Source+Code+Pro:ital,wght@0,200..900;1,200..900&display=swap",
              "rel": "stylesheet",
            ),
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
                  #show: zebraw-init
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

