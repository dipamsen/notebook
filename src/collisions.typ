#import "../template.typ": blog-post, boxed, canvas, numbered
#import "@preview/cetz:0.4.0"

#show: blog-post.with(title: "Elastic Collisions", date: datetime(day: 31, month: 5, year: 2024))


During collision of two spherical masses, the total momentum of the system remains conserved, owing to the lack of any external force present on the system. #footnote[Even if any other force is present, it can be neglected in comparison to the force of collision, which is very large, as it causes a finite change in momentum in infinitesimal time.] Different types of collision are distinguished based on
whether or not they conserve *kinetic energy*.

If the total kinetic energy of the system is conserved, i.e. no energy is dissipated in form of heat, or sound, the
collision is said to be *perfectly elastic*.

= Perfectly Elastic Collisions in Space

Consider two spheres in space having velocities in random directions, such that they collide at some point. Given the
initial conditions, we can determine the final velocities of the spheres after the collision.

There are two possible ways in which this can happen:
1. *Head-on Collision* (1D Collision): The spheres collide along the line joining their centers. (The initial velocities of
  the spheres are along this line.)

2. *Oblique Collision* (2D Collision): The velocities of the spheres are not along the line joining their centers.

== One Dimensional Elastic Collision

#let figa = canvas(length: 0.8cm, {
  import cetz.draw: *
  circle((0, 0), name: "a")

  line((0, 0), (radius: 1.6, angle: 0deg), mark: (end: "stealth", fill: black), name: "v1")
  content("v1.end", h(1mm) + $v_1$, anchor: "west")
  content("a", v(2mm) + $m_1$, anchor: "north")

  group({
    translate((4, 0))
    circle((0, 0), name: "b")

    line((0, 0), (radius: 1.5, angle: 0deg), mark: (end: "stealth", fill: black), name: "v2")
    content("v2.end", h(1mm) + $v_2$, anchor: "west")
    content("b", v(2mm) + $m_2$, anchor: "north")
  })
})


#let figb = canvas(length: 0.8cm, {
  import cetz.draw: *
  circle((0, 0), name: "a")

  line((0, 0), (radius: 1.6, angle: 0deg), mark: (end: "stealth", fill: black), name: "v1")
  content("v1.end", h(1mm) + $v'_1$, anchor: "west")
  content("a", v(2mm) + $m_1$, anchor: "north")

  group({
    translate((4, 0))
    circle((0, 0), name: "b")

    line((0, 0), (radius: 1.5, angle: 0deg), mark: (end: "stealth", fill: black), name: "v2")
    content("v2.end", h(1mm) + $v'_2$, anchor: "west")
    content("b", v(2mm) + $m_2$, anchor: "north")
  })
})

#align(center, table(
  stroke: none,
  inset: 0pt,
  columns: 2,
  gutter: 3em,
  figa + [Initial], figb + [Final],
))

The two constraints in the collision are kinetic energy conservation and momentum conservation. Using these relations,
we can determine the final velocities of the spheres.
$
  m_1 v_1 + m_2 v_2 & = m_1 v'_1 + m_2 v'_2
$
#numbered[
  $
    => m_1 (v_1 - v'_1) & = m_2 (v'_2 - v_2 )
  $
]
$
  1 / 2 m_1 v_1^2 + 1 / 2 m_2 v_2^2 & = 1 / 2 m_1 v'_1^2 + 1 / 2 m_2 v'_2^2
$#numbered[$
    => m_1 (v_1^2 - v'_1^2 ) & = m_2 (v'_2^2 - v_2^2)
  $
]


Dividing (2) by (1), we get:

$
  (m_1 (v_1^2 - v'_1^2)) / (m_1 (v_1 - v'_1)) & = (m_2 (v'_2^2 - v_2^2)) / (m_2 (v'_2 - v_2)) \
                                => v_1 + v'_1 & = v'_2 + v_2                                  \
                               => v'_1 - v'_2 & = v_2 - v_1
$

Using the above relation, along with (1), we have a system of two linear equations in two variables, which can be solved
to find the final velocities of the spheres.

#numbered[$
    v'_1 - v'_2 = v_2 - v_1\
  $ $
    m_1 v'_1 + m_2 v'_2 = m_1 v_1 + m_2 v_2\
  $
]

Multiply (3) by $m_1$ and subtract from (4), on simplification, we get our solutions:

$
  #boxed[$display(v'_1 &= (m_1 - m_2) / (m_1 + m_2 ) v_1 + (2 m_2)/ (m_1 + m_2) v_2)$] \
  #boxed[$display(v'_2 &= (m_2 - m_1) / (m_1 + m_2 ) v_2 + (2 m_1)/ (m_1 + m_2) v_1)$]
$


#let th = $text(#blue, #$med hat(t)med$)$
#let nh = $text(#red, #$med hat(n)med$)$



== Two Dimensional Elastic Collision

For two non-spinning bodies in two dimensions, to solve for the final velocities, we can resolve the velocities into
components along the line of impact (#nh) and tangent to the bodies at the point of contact (#th). Since the collision
only imparts force along the line of impact, the tangential velocities don't change.

#let fig1 = canvas({
  import cetz.draw: *
  circle((0, 0), name: "a")
  line((0, 0), (radius: 1.2, angle: 15deg), mark: (end: "stealth", fill: black), name: "v1")
  content("v1.end", $v_1$, anchor: "north-west")
  content("a", v(2mm) + $m_1$, anchor: "north")

  translate((2 + calc.sqrt(2), -1))

  circle((0, 0), name: "b")
  line((0, 0), (radius: 1.55, angle: 180deg), mark: (end: "stealth", fill: black), name: "v2")
  content("v2.end", $v_2$, anchor: "north-west")
  content("b", v(2mm) + $m_2$, anchor: "north")
})

#let fig2 = canvas({
  import cetz.draw: *
  circle((0, 0), name: "a")
  line((0, 0), (radius: 1.2, angle: 15deg), mark: (end: "stealth", fill: black), name: "v1")
  content("v1.end", $v_1$, anchor: "north-west")
  content("a", v(2mm) + $m_1$, anchor: "north")

  translate((calc.sqrt(2), -calc.sqrt(2)))

  circle((0, 0), name: "b")
  line((0, 0), (radius: 1.55, angle: 180deg), mark: (end: "stealth", fill: black), name: "v2")
  content("v2.end", $v_2$, anchor: "north-west")
  content("b", v(2mm) + $m_2$, anchor: "north")

  line((-3, 3), (1.5, -1.5), stroke: (dash: "dotted"))
  line((-1, -1), (2, 2), stroke: (dash: "dotted"))
  translate((-calc.sqrt(2), calc.sqrt(2)))
  line((-1, -1), (2, 2), stroke: (dash: "dotted"))

  translate((2.5, -2))
  line((0, 0), (radius: 1, angle: -45deg), mark: (end: ">", fill: red), name: "n", stroke: red)
  content("n.end", h(1mm) + text(red, $hat(n)$) + v(1mm), anchor: "south-west")

  line((0, 0), (radius: 1, angle: 45deg), mark: (end: ">", fill: blue), name: "t", stroke: blue)
  content("t.end", h(1mm) + text(blue, $hat(t)$), anchor: "west")
})


#let fig3 = canvas({
  import cetz.draw: *

  group({
    translate((calc.sqrt(2), -calc.sqrt(2)))


    line((-2.5, 2.5), (1.5, -1.5), stroke: (dash: "dotted"))
    line((-1, -1), (2, 2), stroke: (dash: "dotted"))
    translate((-calc.sqrt(2), calc.sqrt(2)))
    line((-1, -1), (2, 2), stroke: (dash: "dotted"))
  })
  group({
    circle((0, 0), name: "a")
    line((0, 0), (radius: 1.2, angle: 15deg), mark: (end: "stealth", fill: gray), name: "v1", stroke: gray)
    line(
      (0, 0),
      (radius: 1.2 * calc.cos(30deg), angle: 45deg),
      mark: (end: "stealth", fill: blue),
      name: "v1t",
      stroke: blue,
    )
    line(
      (0, 0),
      (radius: 1.2 * calc.sin(30deg), angle: -45deg),
      mark: (end: "stealth", fill: red),
      name: "v1n",
      stroke: red,
    )
    content("v1.end", text(gray, $v_1$), anchor: "north-west")
    content("v1t.end", text(blue, $v_(1t)$) + h(2mm), anchor: "south-east")
    content("v1n.end", text(red, $v_(1n)$), anchor: "east")

    translate((calc.sqrt(2), -calc.sqrt(2)))

    circle((0, 0), name: "b")
    line((0, 0), (radius: 1.5, angle: 180deg), mark: (end: "stealth", fill: gray), name: "v2", stroke: gray)
    line(
      (0, 0),
      (radius: 1.5 * calc.cos(45deg), angle: 180deg - 45deg),
      mark: (end: "stealth", fill: red),
      name: "v2n",
      stroke: red,
    )
    line(
      (0, 0),
      (radius: 1.5 * calc.sin(45deg), angle: 180deg + 45deg),
      mark: (end: "stealth", fill: blue),
      name: "v2t",
      stroke: blue,
    )
    content("v2.end", text(gray, $v_2$), anchor: "north-west")
    content("v2n.end", h(2mm) + text(red, $v_(2n)$), anchor: "west")
    content("v2t.end", text(blue, $v_(2t)$), anchor: "north-west")
  })

  group({
    translate((2.5, -2))
    line((0, 0), (radius: 1, angle: -45deg), mark: (end: ">", fill: red), name: "n", stroke: red)
    content("n.end", h(1mm) + text(red, $hat(n)$) + v(1mm), anchor: "south-west")

    line((0, 0), (radius: 1, angle: 45deg), mark: (end: ">", fill: blue), name: "t", stroke: blue)
    content("t.end", h(1mm) + text(blue, $hat(t)$), anchor: "west")
  })
})

#align(center, table(
  stroke: none,
  inset: 0pt,
  columns: 3,
  gutter: 2.5em,
  align(horizon, fig1), fig2, fig3,
))

Components of velocity in the #nh direction (along the line of impact) can be resolved by using the formula for
one-dimensional elastic collision, whereas velocities in the #th direction remain unchanged.

#align(center, table(stroke: none, inset: 0pt, columns: 2, align: horizon, column-gutter: 3em, row-gutter: 1em)[
  $ v'_(1n) = (m_1-m_2) / (m_1 + m_2)med v_(1n) + (2m_2) / (m_1 + m_2) med v_(2n) $
][
  $ v'_(1t) = v_(1t) $
][
  $ v'_(2n) = (m_2-m_1) / (m_1 + m_2) med v_(2n) + (2m_1) / (m_1 + m_2) med v_(1n) $
][
  $v'_(2t) = v_(2t)$
])

The final velocities $arrow(v'_1)$ and $arrow(v'_2)$ are obtained by the vector sum of the respective #nh and #th components. $ => arrow(v'_1) & = v'_(1n) nh + v'_(1t) th                                                              \
   arrow(v'_1) & = lr(((m_1-m_2)/(m_1 + m_2)med v_(1n) + (2m_2)/(m_1 + m_2) med v_(2n))) nh + v_(1t) th \ $
This is the value of
$arrow(v'_1)$ in terms of components of initial velocities, and unit vectors along the line of impact and tangent to it.
This can be converted into a vector expression, by subtracting the initial velocity vector $arrow(v_1)
= v_(1n) nh + v_(1t) th$ from $arrow(v'_1)$.

Subtracting $arrow(v_1)$ from $arrow(v'_1)$, $ arrow(v'_1) - arrow(v_1) & = (lr(((m_1-m_2)/(m_1 + m_2)med v_(1n) + (2m_2)/(m_1 + m_2) med v_(2n))) nh + med
                             cancel(v_(1t) th)) - (v_(1n) nh + med cancel(v_(1t) th))                      \
                         & = ((m_1-m_2)/(m_1 + m_2)med v_(1n) + (2m_2)/(m_1 + m_2) med v_(2n) - v_(1n)) nh \
                         & = ((-2m_2)/(m_1 + m_2)med v_(1n) + (2m_2)/(m_1 + m_2) med v_(2n)) nh            \
                         & = (2m_2)/(m_1 + m_2)med (v_(2n) - v_(1n)) nh                                    \ $
Here, we can substitute
$v_(1n) = arrow(v_1) dot nh$ and $v_(2n) = arrow(v_2) dot nh$. $ arrow(v'_1) = arrow(v_1) + (2m_2)/(m_1 + m_2)med ((arrow(v_2) - arrow(v_1)) dot nh) nh\ $
The unit vector along the line of impact,
$nh$, is in the direction of the difference of position vectors of bodies 1 and 2. If $arrow(x)$ denotes the position
vector of the centre of the body, $ nh = (arrow(x_2) - arrow(x_1))/(|arrow(x_2) - arrow(x_1)|) $
#pagebreak(weak: true)
By substituting all values, we get a vector expression for
$arrow(v'_1)$. The expression of $arrow(v'_2)$ can be symmetrically obtained. $ #boxed($display(
  arrow(v'_1) = arrow(v_1) + (2 m_2) / (m_1 + m_2) ((arrow(v_2) - arrow(v_1)) dot (arrow(x_2) - arrow(x_1)))/(|arrow(x_2) - arrow(x_1)|^2) (arrow(x_2) - arrow(x_1))
)$)\
#boxed($display(
  arrow(v'_2) = arrow(v_2) + (2 m_1) / (m_1 + m_2) ((arrow(v_1) - arrow(v_2)) dot (arrow(x_1) - arrow(x_2)))/(|arrow(x_1) - arrow(x_2)|^2) (arrow(x_1) - arrow(x_2))
)$) $
#v(3em)
#align(center, line(length: 50%))

