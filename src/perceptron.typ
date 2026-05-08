#import "../template.typ": blog-post, custom-css, diagram, hscroll, polyfill-html, output-format, canvas, boxed-content, boxed
#import "@preview/cetz:0.4.0"
#import "@preview/fletcher:0.5.8" as fletcher: edge, node
#import "@preview/zebraw:0.6.1": zebraw

#show: blog-post.with(title: "The perceptron, and beyond", date: datetime(
  day: 3,
  month: 3,
  year: 2026
), description: "A story about the humble perceptron, and how it laid the foundations for modern deep learning.")

#let bu(x) = math.bold(math.upright(x))

#quote(
  [[The perceptron] is the embryo of a computer that will be able to walk, talk see, write, reproduce itself and be conscious of its existence.],
  attribution: [Frank Rosenblatt, 1958 (as reported by the New York Times)],
  block: true
)

Today's large language models (LLMs) are highly sophisticated systems and can perform a wide variety of tasks, including reasoning, writing code, and even simulating poetry. But, if you look into the inner workings of these models, they are composed of billions of *multilayer perceptrons* -- a structure once dismissed by the pioneers of AI for being too simple to be useful, but now used in almost every AI system.

In the early days of machine learning, researchers were inspired by the most powerful system capable of intelligence: the human brain. It was known, that the brain is composed of a large network of neurons, each of which is connected to other neurons. 

// image of a neuron
#figure(image("media/neuron.png", width: 70%), caption: [A diagram of a biological neuron])


At any instant, a neuron has a threshold value; if the excitation of the neuron exceeds this threshold, the neuron fires an action potential (an impulse), which in turn excites or inhibits other neurons connected to it. More precisely, a neuron receives weighted electrochemical signals across its synapses, and if the sum of these inputs exceeds the threshold, it fires — propagating the signal down its axon to downstream neurons.

In 1943, Warren McCulloch and Walter Pitts proposed a mathematical model on how biological neurons fire, and showed that networks of such simplified neurons could compute any logical proposition, effectively demonstrating that neural networks were capable of universal logical computation.

A psychologist, Donald Hebb, proposed a rule for how biological learning happens (Hebbian learning), which is famously summarised as "neurons that fire together, wire together". He theorized that learning consists of the strengthening or weakening of synaptic connections between neurons based on experience. This approach to artificial intelligence, where intelligence is treated as an emergent behaviour of a large network of interconnected units, came to be known as *connectionism*.

Based upon the existing knowledge of the human nervous system, and previous work on connectionism, Frank Rosenblatt (1958) devised a machine called the *perceptron*, a computational model that mimicked the way biological neurons process information. 

== Rosenblatt's perceptron

The perceptron takes in a set of binary inputs, multiplies each by a corresponding numerical weight (representing synaptic strength), and sums the result. If the weighted sum exceeds a fixed threshold, the perceptron fires; outputting a 1, otherwise it outputs a 0.



#let color(body) = {
  set text(fill: orange)
  body
}

#figure(diagram({
  node((0, 0), $sum$, stroke: 1pt, shape: circle)

  node((-2, -2), $x_1$)
  node((-2, -1), $x_2$)
  node((-2, 0), $dots.v$, stroke: none)
  node((-2, 1), $x_n$)
  node((-2, 2), $1$)

  edge((-2, -2), (0, 0), color[$w_1$], "-|>", label-side: right, label-sep: 0mm)
  edge((-2, -1), (0, 0), color[$w_2$], "-|>", label-side: right, label-sep: 0mm)
  edge((-2, 1), (0, 0), color[$w_n$], "-|>", label-sep: 0mm)
  edge((-2, 2), (0, 0), color[$b$], "-|>", label-sep: 0mm)

  node((2, 0), {
    box(line(length: 3mm, stroke: white))
    box(line(length: 6mm, stroke: white, angle: 90deg))
    box(line(length: 3mm, stroke: white), baseline: -1.5em)
  }, stroke: 1pt, shape: circle)
  node((2, 0.5), $g(z)$)
  edge((0, 0), (2, 0), $z$, "-|>")

  edge((2, 0), (3, 0), "-|>")
  node((3, 0), $y$)
}), caption: [Mathematical description of the perceptron])


The perceptron can be understood as a binary classifier. It learns a function that maps its inputs $bu(x)$ to a single binary value $y in {0, 1}$.

$
  f(bu(x)) = g(z) = g(w_1 x_1 + w_2 x_2 + dots + w_n x_n + b)
$

where $g$ is called the *activation function*, which in this case is a threshold (step) function.

$
  g(z) = cases(1 quad &"if" z > 0, 0 quad &"otherwise")
$

Rosenblatt physically realised the perceptron as a machine, called the *Mark I Perceptron*, built at the Cornell Aeronautical Laboratory and funded by the US Navy. The machine was designed to perform image recognition. Its 'retina' consisted of a grid of 400 photocells, called sensory units. The outputs of these sensory units were connected randomly to a layer of 512 perceptrons, called association units. Finally, the outputs of the association layer were connected to the output layer of 8 perceptrons, called response units. The connections between the A-units and the R-units had adjustable weights, encoded using potentiometers. These weights were 'learned' by adjusting the potentiometers using electric motors during the learning process.

#figure(image("media/mark-1.png"), caption: [
  Rosenblatt and the Mark I Perceptron
])

== Learning

The perceptron was a simple yet powerful machine. It could learn to distinguish simple visual patterns, such as telling apart circles from squares, without being explicitly programmed any rules. Instead, it discovered its own rules by observing the patterns it was exposed to.

Rosenblatt introduced the perceptron learning rule, which is a simple iterative procedure that adjusts the weights of the perceptron so that it correctly classifies a set of labelled training examples. Initially, the perceptron is given a random set of weights.

For a given training example, the perceptron's output is compared to the desired output. There are three possible outcomes:
- *Correct*: the output matches the label. The weights remain unchanged.
- *False positive*: the perceptron outputs a 1, but the label is 0. The weights of all active inputs are decreased by some amount, making it less likely to fire on similar inputs.
- *False negative*: the perceptron outputs a 0, but the label is 1. The weights of all active inputs are increased by some amount, making it more likely to fire on similar inputs.

This process is repeated, cycling through the training examples, until the perceptron classifies all of them correctly.

The learning rule can be formally described by the following update rule:
$
  w <- w + eta (y - hat(y)) bu(x)
$

where $y$ is the desired output, $hat(y)$ is the perceptron's output, and $eta$ is some constant value, called the *learning rate*. 

== Correctness and convergence

Not only is the learning rule simple and elegant, but it also has a convergence guarantee: If the perceptron is capable of learning the training examples and classifying them correctly, then the learning rule will converge to a set of weights that correctly classifies all of the training examples; in a finite number of iterations. (*Convergence Theorem*)

#boxed-content[
*Convergence Theorem*: _Given a dataset $D$, such that $max ||x||_2 = beta$, and it is linearly separable by some unit vector $w^*$ by margin $gamma$:
$
gamma = min_(x) |w^* dot x|
$
then the perceptron learning algorithm converges after making at most $beta^2\/gamma^2$ misclassifications._

_Proof_: Suppose at some point, the perceptron misclassifies data point $(x^((i)), y^((i)))$. WLOG, assume $y^((i)) = 1$. Then the update rule is:
$
  w' = w + eta x^((i))
$
Then if we consider the inner product of $w'$ and $w^*$, we get:
$
  w^* dot w' = w^* dot w + eta x^((i)) dot w^*
$

But $x^((i)) dot w^* >= gamma$, thus $w^* dot w' >= w^* dot w + eta gamma$. This means, the update rule will increase the inner product of $w'$ and $w^*$ at each misclassification by at least $eta gamma$. So after $k$ iterations, the inner product of $w$ and $w^*$ will be at least $k eta gamma$. $(1)$
$
  w^* dot w_k >= k eta gamma
$

Now consider the norm of $w$:
$
  ||w'||_2^2 = ||w + eta x^((i))||_2^2 = |||w||^2 + eta^2 ||x^((i))||_2^2 + 2 eta x^((i)) dot w
$

Here, $||x^((i))||_2^2 <= beta^2$, and $2 eta x^((i)) dot w <= 0$ (since this example was misclassified). So:
$
  ||w'||_2^2 <= ||w||^2 + eta^2 beta^2
$
Thus, the squared norm of $w$ increases at each misclassification by at least $eta^2 beta^2$. This means, after $k$ iterations, the squared norm of $w$ will be at least $k eta^2 beta^2$. $(2)$
$
  ||w_k||_2^2 >= k eta^2 beta^2
$

Combining $(1)$ and $(2)$, and applying the Cauchy-Schwarz inequality, we get:
$
  &=> k eta gamma <= w_k dot w^* <= ||w_k||_2 <= sqrt(k) eta beta \
  &=> k eta gamma <= sqrt(k) eta beta\
  &=> #boxed[$ k <= beta^2 \/ gamma^2 $]
$
]

While the perceptron algorithm is guaranteed to converge on some solution

= Draft

things to talk about:
- convergence guarantee
- linear classifier --> minsky papert
- claims by the new york times


= References

1. W. McCulloch, J. Pitts. A logical calculus of the ideas immanent in nervous activity.

2. F. Rosenblatt. The Perceptron: A Probabilistic Model for Information Storage and Organization in the Brain.

3. #link("https://en.wikipedia.org/wiki/Perceptron")[Perceptron] on Wikipedia