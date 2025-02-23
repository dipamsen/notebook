#import "@preview/showybox:2.0.3": showybox as sb
#import "../template.typ": blog-post, polyfill-html, boxed

#show: blog-post.with(
  title: "100 Boxes",
  date: datetime(day: 19, month: 2, year: 2024),
)

#let showybox = (..args) => polyfill-html(block: true, class: "showybox")(block(width: 500pt, sb(..args)))


#showybox[A man have been given a random number from 1-100 and then sent to a room having 100 boxes containing a random number. He can check maximum of 50 boxes to find his number. What is the probability that he will find his number?]


_Intuitively, the answer to this question is $1/2$, this article tries to mathematically arrive to the answer by using Conditional Probabilities and the Total Probability Theorem. [Disclaimer: This is a very overcomplicated way to arrive to the result.]_

*Solution*

Here, there exist two random elements - selection of number, and arrangement of boxes in the room - making it difficult to perform a probability calculation. Let us fix one of them for now. Say, his randomly chosen number is $N = 10$.

Now, let us assume that the boxes are arranged randomly, and he checks them in order of their positioning. So he checks the first box, then the second, then the third, and so on.

Let $A_n$ denote the event that he finds his number (10) in the $n^"th"$ box.

Before he opens any box, he has no knowledge of any number, so the probabilities are:

$ P(A_1) = 1 / 100, P(A_2) = 1 / 100, P(A_3) = 1 / 100, ..., P(A_100) =1 / 100 $
// $A_2 = 99/100 dot 1/99$ (his number is not in box 1, and is in box 2 (which had 99 possibilities))\
// $A_3 = 99/100$

Once he has opened box 1, he suddenly has gained new information, which is the number in box 1. There are two cases:

*Case 1:* He has found his number (Success), $A_1$: Now the probabilities will become:

$ P(A_1 / A_1) = 100 / 100, P(A_2 / A_1) = 0, P(A_3 / A_1) = 0, ..., P(A_100 / A_1) =0 $

*Case 2:* He has not found his number, $A'_1$: Now the probabilities will become:

$ P(A_1 / A'_1) = 0, P(A_2 / A'_1) = 1 / 99, P(A_3 / A'_1) = 1 / 99, ..., P(A_100 / A'_1) =1 / 99 $

(He will equally distribute the probabilty in all the remaining boxes)

So clearly, the probability values $A_n$ are not static but instead dynamic, i.e. they change as per information gained by the player. These are denoted as conditional probabilities. (Incidentally, this concept is key to understanding many famous probability "paradoxes", like the Monty Hall Problem for example.)

So, to find the overall probability $A_2$, we can use the Total Probability theoremn:

$
  P(A_2) &= P(A_1 inter A_2) + P(A'_1 inter A_2)\ &= P(A_1)P(A_2 / A_1) + P(A'_1)P(A_2 / A'_1)\
  &= 1 / 100 dot 0 + 99 / 100 dot 1 / 99\ &= 1 / 100
$

Similarly, for $A_3$ we can write

$
  P(A_3) &=&& P(A_2 inter A_3) + P(A'_2 inter A_3)\
  &=&& P(A_1 inter A_2 inter A_3) + P(A'_1 inter A_2 inter A_3) + P(A_1 inter A'_2 inter A_3) + \ &&& P(A'_1 inter A'_2 inter A_3)
$

These are all the possibilities of $A_1$ and $A_2$, which might have occured before opening the third box. But, we can clearly see, just like the above case, here the first three terms will become 0. This is because all $A_n$ are disjoint events, and hence they cannot occur simultaneously. So any event of the type $A_i inter A_j$ will obviously become an impossible event.

So, we can simplify to:

#{
  set text(0.8em)
  $
    P(A_1) &= P(A_1) &&= P(A_1) &&= 1 / 100\
    P(A_2) &= P(A'_1 inter A_2) &&= P(A'_1)P(A_2 / A'_1) &&= 99 / 100 dot 1 / 99\
    P(A_3) &= P(A'_1 inter A'_2 inter A_3) &&= P(A'_1)P(A'_2 / A'_1)P(A_3 / (A'_1 inter A'_2)) &&= 99 / 100 dot 98 / 99 dot 1 / 98\
    P(A_4) &= P(A'_1 inter A'_2 inter A'_3 inter A_4) && = P(A'_1)P(A'_2 / A'_1) ... P(A_4 / (A'_1 inter A'_2 inter A'_3)) &&= 99 / 100 dot 98 / 99 dot 97 / 98 dot 1 / 97
  $
}

Following the pattern, we can say that $A_n = 1/100$, for every $n$. (We could've directly stated this without doing any calculations, that it is equally likely that he finds his number in any of the boxes, because the order of arrangement is random.)

Now, this result is obviously not specific for $N=10$, it is true for any $N$, and all $N$ are equally likely to be picked. So, the final result we will get, is that $A_n = 1/100$, meaning each $A_n$ is equally likely.


Now since $A_1, A_2, ..., A_50$ is mutually exclusive, we can write:

$
  P("Success") = frac("Favourable", "Total") &= P(A_1 union A_2 union A_3 union A_4 union ... union A_50) /  1\ & =50 times 1/100  = #boxed($ 1/2 $)
$

