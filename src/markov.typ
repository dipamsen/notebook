#import "../template.typ": blog-post, custom-css, diagram, hscroll, polyfill-html, output-format
#import "@preview/cetz:0.4.0"
#import "@preview/fletcher:0.5.8" as fletcher: edge, node
#import "@preview/zebraw:0.6.1": zebraw

#show: blog-post.with(title: "Markov Chains and Dynamic Programming", date: datetime(
  day: 9,
  month: 5,
  year: 2026,
))

Markov chains are a powerful mathematical tool for modelling a variety of random processes, and answering questions about them. Here, we look at what they are, and use them to solve some problems.

= Markov Chains

A Markov chain is a random process which follows the _Markovian property_: At any point in time, the probability of the next event only depends on the current state.

For example, consider a random walk on the integers line, starting at 0. At each step, there is a 50% chance that the agent moves right by one step, or left by one step. Here, the 'state' of the system is where the agent currently is situated. The next move of the agent is probabilistic, but it only depends on the current state, not the past history of states. Thus, this process can be modelled as a Markov chain.

More formally, a *(discrete-time) Markov chain* is a sequence of random variables $X_i$, where $P(X_(n + 1) = x | X_1, X_2, ..., X_n) = P(X_(n + 1) = x | X_n)$ (distribution of $X_(n + 1)$ only depends on $X_n$).

Markov chains can be represented by state diagrams. For example, the following is a Markov chain with two states which models the weather of a hypothetical city:

#figure(diagram({
  node([#emoji.sun], shape: circle, stroke: 1pt, name: "A")

  node((2, 0), [#emoji.cloud.rain], stroke: 1pt, name: "B")

  edge(<A>, "-|>", <A>, bend: 130deg, loop-angle: 180deg, label: $0.8$)
  edge(<B>, "-|>", <B>, bend: 130deg, loop-angle: 0deg, label: $0.6$)

  edge(<A>, "-|>", <B>, bend: 30deg, label: $0.2$)
  edge(<B>, "-|>", <A>, bend: 30deg, label: $0.4$)
    
}), caption: [State diagram for a 2-state Markov chain])

In the above Markov chain, there are two states, corresponding to sunny and rainy weather. Suppose the weather is sunny on some day, then on the next day, the weather will be sunny again with a probability of 0.8, and it will be rainy the next day with a probability of 0.2. 

Here, the probability distribution of the weather of any day only depends on the weather of the previous day, so the process is Markovian.

We can mathematically represent the Markov chain's transitions in the form of a matrix, called a _transition matrix_:

$
P = mat(0.8, 0.2; 0.4, 0.6)
$

where $P_(i j)$ denotes the transition probability from state $i$ to state $j$. For the transition matrix to be well defined, we need each row to add up to $1$. (Equivalently, in the state diagram, all outgoing transitions from any given state must add up to $1$.)

// A question we may ask about this random process is, in the long run, what fraction of days are sunny/rainy? We will come back to this question later.

Let's look at another Markov chain, the one modelling a random walk over the integers.

#figure(diagram({
  node((-4, 0), $...$, name: "−4")
  node((4, 0), $...$, name: "4")
  for i in range(-3, 4) {
    node((i, 0), {set text(0.8em);$#i$}, shape: circle, stroke: 1pt, radius: 1em, name: str(i))
  }
  for i in range(-4, 4) {
    edge(label(str(i)), "-|>", label(str(i + 1)), bend: 30deg, label: $0.5$)
  }
  for i in range(-3, 5) {
    edge(label(str(i)), "-|>", label(str(i - 1)), bend: 30deg, label: $0.5$)
  }
}), caption: [Markov chain modelling a random walk])

This Markov chain has a countable state space. From each state $k$ there are two possible transitions, each with a 50% chance, to states $k + 1$ and $k - 1$.// A question we could ask about this system is, what is the expected number of moves after which the agent would hit 0 again?

= The Coin Problem

Consider the following probability problem:

#quote(block: true)[
  Find the expected number of coin tosses required, to get a sequence of $N$ consecutive heads.
]

If we denote by $X_N$ the random variable for the number of coin tosses after which we get $N$ consecutive heads for the first time, then we need to find $EE[X_N] = sum_(x=N)^oo x med P(X_N = x)$.

It is easy to notice that calculating these probability values $P (X_N = k)$ is not a trivial task.

Instead, let's start with an easier problem, what is the expected number of coin tosses required to get heads? This is the same problem, but with $N = 1$.

In this case finding the probabilities is simple, $P(X_1 = k) = (1/2)^k$, as exactly one sequence ($T T T ... T H$) corresponds to the case of $X_1 = k$.

So, the required expectation is $X_1 = sum_(k=1)^oo k / 2^k = 2$.

Another way to realise this is that $X_1 ~ "Geom"(1/2)$, and $EE[X_1] = 1/(1\/2) = 2$.

What about the $N = 2$ case? Again, finding the individual probabilities is not trivial. But, by careful observation, one can notice that this can be modelled using a Markov chain.

Here, the states denote the number of consecutive heads seen yet, which can be 0, 1 or 2. At each step, we flip a coin, and we get one more consecutive heads, or we get a tails, which resets our head count. Since the state transition only depends on the previous state, this process is Markovian.

#figure(
  diagram({
    node($0$, shape: circle, stroke: 1pt, name: "0")
    node((1, 0), $1$, shape: circle, stroke: 1pt, name: "1")
    node((2, 0), $2$, shape: circle, stroke: 1pt, name: "2")

    edge(<0>, "-|>", <1>, label: $(H) thick 0.5$)
    edge(<1>, "-|>", <2>, label: $(H) thick 0.5$)
    edge(<0>, "-|>", <0>, label: $(T) thick 0.5$, bend: 135deg, loop-angle: 180deg)
    edge(<1>, "-|>", <0>, label: $(T) thick 0.5$, bend: 45deg, loop-angle: 180deg)
    edge(<2>, "-|>", <2>, label: $1$, bend: 135deg, loop-angle: 0deg)
  }, spacing: 5em),
  caption: [Markov chain for the above problem]
)

Here, the state $2$ is called an 'absorbing state', as once we reach this state, we don't do any more coin tosses and remain on this state indefinitely (represented as a single transition $2 -> 2$ with probability $1$). We start at the state $0$. On each coin flip, we transition according to the state diagram, corresponding to $H$ or $T$, keeping track of the number of consecutive heads seen till now. 

What we need to compute is the expected number of transitions after which we reach the absorbing state. This is often termed as the 'hitting time'.

Denote as $k_i$ the expected hitting time when starting from state $i$. Then, from the structure of the Markov chain, we can write some equations based on the transitions:

$
k_0 &= 1 + 1/2 k_0 + 1/2 k_1\
k_1 &= 1 + 1/2 k_0 + 1/2 k_2\
k_2 &= 0
$

which we can simplify to get
$
k_0 &= 1 + 1/2 k_0 + 1/2 (1 + 1/2 k_0)\
&= 3/2 + 3/4 k_0\
=> k_0 / 4 &= 3 / 2 => k_0 = 6
$

which is the answer to our problem.

We can immediately generalise our Markov chain for any general $N$: 

- We start at state $0$.
- At each state $i$, if we get heads, we move to state $i + 1$. If we get tails, we reset to state $0$.
- State $N$ is the absorbing state.

Thus we can write our equations as

$
k_N &= 0\
k_i &= 1 + 1/2 k_0 + 1/2 k_(i + 1)
$

We need to find $k_0$. To solve the system, we can repeatedly substitute:

$
k_(N - 1) &= 1 + 1/2 k_0 \
k_(N-2) &= 1 + 1/2 k_0 + 1/2 (1 + 1/2 k_0) = 3/2 + 3/4 k_0\
k_(N - 3) &= 1 + 1/2 k_0 + 1/2 (3/2 + 3/4 k_0) = 7/4 + 7/8 k_0\
&dots.v\
k_(N - k) &=  (2^k - 1) / (2^(k - 1)) + (2^k -1) / 2^k k_0\
=> k_0 &= (2^N - 1) / (2^(N - 1)) + (2^N -1) / 2^N k_0\
=> k_0 / 2^N &= (2^N - 1) / (2^(N - 1)) => k_0 = 2 (2^N - 1)
$
which is the required answer.

= Formalism

We can formalise the technique we used above to calculate the expected hitting time in a Markov chain.

Consider a Markov chain. Let $p_(i j)$ denote the transition probability from state $i$ to state $j$. Let $A$ be a subset of states which are the absorbing states. Represent by $k_i^A$ the expected hitting time for $A$, if starting at state $i$. Then, we can show that the vector of expected hitting times, $bold(upright(k^A))$ is the *minimal non negative solution*  to the following system of equations:

$
cases(k_i^A = 0 quad quad &"for" i in A, k_i^A = 1 + sum_(j in.not A) p_(i j) thin k_j^A quad &"for" i in.not A)
$

To show correctness, first note that for $i in A$, since $i$ is already an absorbing state, the expected hitting time is $0$, so $k_i^A = 0$.

For any other state $i in.not A$, let $H^A$ denote the hitting time. So, $k_i^A = EE(H^A | X_0 = i)$.

Since $X_0 = i in.not A$, $EE(H^A) >= 1$. By the Markov property, we can write,
$
EE(H^A | X_0 = i, X_1 = j) = 1 + EE(H^A | X_0 = j)
$

So, we have 
$
EE(H^A | X_0 = i) &= sum_(j) EE(H^A | X_1 = j, X_0 = i)  thin P(X_1 = j | X_0 = i)\
&= sum_j (1 + EE(H^A | X_0 = j)) p_(i j)  = 1 + sum_(j in.not A) p_(i j) k_j^A
$

(For the proof of the minimality condition, see Theorem 1.3.5 in Markov Chains by JR Norris.)

= Dynamic Programming

Let's look at an example where we can use Markov chains to formulate the expected hitting time equations, and use dynamic programming to compute the answer.

Consider the following problem: (Adapted from: Atcoder Educational DP Contest)

#quote(block: true)[
There are $N$ dishes, numbered from $1$ to $N$. Initially for each $i$, dish $i$ has $a_i$ ($1 <= a_i <= 3$) pieces of sushi on it. You perform the following operation repeatedly until all the pieces of sushi are eaten:
- Randomly choose a dish $i$, $1 <= i <= N$. If dish $i$ is not empty, eat a piece of sushi from that dish.
What is the expected number of operations performed?
]

Once again, this problem can be modelled by a Markov chain. 

An initial choice of the state of the system can be the counts of pieces of sushi on each dish at some time. So, the initial state will be $(a_1, a_2, ..., a_N)$, and the final (absorbing) state is $(0, 0, ..., 0)$. Transitions will be with probability $1/N$, decrease by one the value of the $i$th dish (if it is non-zero, or stay on the same state otherwise).

This is a perfectly fine choice of state definition, but the total number of states here is $~ 3^N$, which is impractical to represent in a dynamic programming solution.

Here, we can actually compress our state space, by only keeping relevant information for our needs. We define our states and transitions as follows:

- A state $(i, j, k)$ represents that there are $i$ dishes with one piece of sushi, $j$ dishes with two pieces of sushi, $k$ dishes with three pieces of sushi, and the rest of the dishes have no pieces of sushi.
- Initial state is $(\#1(a), \#2(a), \#3(a))$ and the final absorbing state is $(0, 0, 0)$ (all dishes are empty).
- With probability $i \/ N$, we transition to the state $(i - 1, j, k)$ (choose a dish with one piece of sushi), with probability $j \/ N$, we transition to the state $(i + 1, j - 1, k)$ (choose a dish with two pieces of sushi), with probability $k \/ N$, we transition to the state $(i, j + 1, k - 1)$ (choose a dish with three pieces of sushi), and with probability $1 - (i + j + k) / N$ we stay on the same state (choose an empty dish).

We can clearly see the advantage here, we only require $~N^3$ states under this definition.


Now, using our above theorem, we can write down the relations between the hitting times. We need to find the hitting time to the state $(0, 0, 0)$, starting from our initial state. Let $T(i, j, k)$ denote the hitting time from state $(i, j, k)$. Then,

$
T(i, j, k) = 1 &+ (1 - (i + j + k) / N) T(i, j, k) + i/ N T(i - 1, j, k) \ &+ thick j / N T (i + 1, j - 1, k) + k / N T(i, j + 1, k - 1) $$

=> T(i, j, k) = N / (s) + i / (s ) T(i - 1, j, k) + j / s T(i + 1, j - 1, k) + k / s T(i, j + 1, k - 1)
$

We have, $T(0, 0, 0) = 0$, and we need to find $T(\#1(a), \#2(a), \#3(a))$.

Note that the recurrence relation of $T(i, j, k)$ depends on both states with $i - 1$ and $i + 1$, so finding an appropriate ordering for doing a bottom-up computation is not trivial. So, we can get a memoized recursive top-down solution. 

Though, we can say that the recursion must terminate, as the transitions always decrease the weighted value $i + 2 j + 3 k$.  (This can be used to get a topological ordering to get a bottom-up solution!)

Here's the recursive implementation of the above DP:

#hscroll[```cpp
double solve(int i, int j, int k, int n, vector<vector<vector<double>>> &dp) {
    if (i == 0 && j == 0 && k == 0) return 0;
    if (dp[i][j][k] > 0) return dp[i][j][k];
    
    double ans = 0, s = i + j + k;
    if (i) ans += solve(i - 1, j,     k,     n, dp) * i / s;
    if (j) ans += solve(i + 1, j - 1, k,     n, dp) * j / s;
    if (k) ans += solve(i,     j + 1, k - 1, n, dp) * k / s;
    
    return dp[i][j][k] = ans + (double)n / s;
}
```]

As we saw through these examples, Markov chains allow us to cleanly express the behaviour of a random process in a mathematical way. Most probabilistic processes can be modelled as Markov chains, and we can use the properties of Markov chains to answer questions about these processes. 