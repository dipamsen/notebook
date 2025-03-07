#import "../template.typ": blog-post, canvas, numbered, boxed
#import "@preview/cetz:0.3.2"
#import "@preview/typsium:0.2.0": ce
#import "@preview/fletcher:0.5.6": diagram, node, edge

#show: blog-post.with(
  title: "Frost Diagrams",
  date: datetime(day: 7, month: 3, year: 2025),
)

#show math.equation.where(block: false): math.display

This is an explanation of Frost diagrams - what they are, what do they show, and how they can be used to determine the stability of species in different oxidation states. There is lot of confusion around the topic, given that the Wikipedia page on the topic has incorrect information (at the time of writing).

= Redox Reactions

A redox reaction is one, where the oxidation state of its reactants changes. In such a reaction, two processes - oxidation and reduction - occur simultaneously. For example, in the reaction between zinc and copper ions, zinc is oxidized to zinc ions, while copper ions are reduced to copper. The reaction can be written as follows:

$
  &ce("Zn + Cu^(2+) -> Zn^(2+) + Cu")\
$

where we have the following half-reactions:

$
  "Oxidation": ce("Zn -> Zn^(2+) + 2e^-")\
$

$
  "Reduction": &ce("Cu^(2+) + 2e^- -> Cu")\
$

#let E0 = $E^circle.small$
#let E0red = $E_"red"^circle.small$
#let E0ox = $E_"ox"^circle.small$
#let E0cell = $E_"cell"^circle.small$
#let E0cat = $E_"cat"^circle.small$
#let E0an = $E_"an"^circle.small$

For any half reaction, we can define its standard reduction potential (#E0red), which is the potential difference between the electrode and the electrolyte, under standard conditions (for the reduction half-reaction).

For a redox reaction, we can define the standard cell potential (#E0cell) as the difference between the standard reduction potentials of the reduction and oxidation half-reactions:

$
  E0cell = E0cat - E0an\
$

where #E0cat is the standard reduction potential of the cathode and #E0an is the standard reduction potential of the anode.

The standard cell potential can be used to determine the feasibility of a redox reaction. If the standard cell potential is positive, the reaction is spontaneous, while if it is negative, the reaction is non-spontaneous. This can be directly related to the Gibbs free energy change of the reaction:

$
  &Delta G^circle.small = -n F E0cell\
$

where $n$ is the number of electrons transferred in the reaction and $F$ is the Faraday constant.

= Latimer Diagrams

A given element can exist in multiple different oxidation states. For example, oxygen can exist in 0, -1 or -2 oxidation states.
Now, we want to summarise the redox behaviour of these species in a diagram. We can write all the species in order of their oxidation state (from the most oxidised form to the most reduced form), and write the standard reduction potential for different half reactions on arrows connecting the species. This diagram is called a Latimer diagram.

#let d1 = {
  // set text(1.4em)
  diagram(
    {
      let O2 = ce("O2")
      let H2O2 = ce("H2O2")
      let H2O = ce("H2O")

      let small(t, size: 0.6em) = {
        set text(size)
        t
      }

      node((0, 0), O2)
      edge("->")[#small($0.68 "V"$, size: 0.8em)]
      node((1, 0), H2O2)
      edge("->")[#small($1.78 "V"$, size: 0.8em)]
      node((2, 0), H2O)
      edge((0, 0), "d,r,r,u", "->", label-side: right)[#small($1.23 "V"$, size: 0.8em)]

      node((0, -0.4), small($0$))
      node((1, -0.4), small($-1$))
      node((2, -0.4), small($-2$))
    },
    spacing: (20mm, 6mm),
  )
}

#let latimer(species: (), os: (), pot: ()) = figure({
  // set text(1.4em)
  diagram(
    {
      let small(t, size: 0.6em) = {
        set text(size)
        t
      }

      for i in range(species.len()) {
        node((i, 0), ce(species.at(i)))
        node((i, -0.5), $small(#(if os.at(i).signum() == 1 {$+$} else {}) #os.at(i))$)
      }

      for i in range(pot.len()) {
        edge((i, 0), "->", (i + 1, 0))[#small($pot.at(#i) "V"$, size: 0.8em)]
      }
    },
    spacing: (14mm, 6mm),
  )
})

#figure(d1)

From the above diagram we can tell the standard reduction potential of the following half-reactions:

$
  ce("O2 + 2 H^+ + 2e^- -> H2O2")\ E0 = 0.68 V\
$

$
  ce("H2O2 + 2H^+ + 2e^- -> 2H2O")\ E0 = 1.78 V\
$

$
  ce("O2 + 4H^+ + 4e^- -> 2H2O")\ E0 = 1.23 V\
$

Note that the potentials are not additive. For a successive reaction, the free energy change is the sum of the free energy changes of the individual reactions. The standard cell potential is a weighted average of the standard reduction potentials of the half-reactions:

$
  Delta G = Delta G_1 + Delta G_2\
  => -(n_1 + n_2) F E0 = -n_1 F E0_1 - n_2 F E0_2\
  => E0 = (n_1 E0_1 + n_2 E0_2) / (n_1 + n_2)\
$

So, thus we have

$
  E0 (ce("O2 -> H2O")\) &= ((2 times E0 \(ce("O2 -> H2O2")\) + 2 times E0 \(ce("H2O2 -> H2O")\))) / 4\
  &= ((2 times 0.68 "V"+ 2 times 1.78 "V")) / 4\
  &= 1.23 "V"\
$


The following is the Latimer diagram for Chlorine in acidic conditions:

#latimer(
  species: ("ClO4^-", "ClO3^-", "HClO2", "HClO", "Cl2", "Cl^-"),
  os: (7, 5, 3, 1, 0, -1),
  pot: (1.2, 1.18, 1.65, 1.63, 1.36),
)

Say we want to find the standard reduction potential for the half-reaction:

$
  ce("HClO (aq) + H^+ (aq) + 2e^- -> Cl^- (aq) + H2O (l)")\
$

From the Latimer diagram, we know the standard reduction potential for the following half-reactions:

$
  ce("2 HClO + 2 H^+ + 2e^- -> Cl2 + 2 H2O")\
  E0 = 1.63 V\
  ce("Cl2 + 2e^- -> 2 Cl^-")\ E0 = 1.36 V\
$
Hence,
$
  Delta G_1 = -n_1 F E0_1 = -2 F times 1.63 "V"\
  Delta G_2 = -n_2 F E0_2 = -2 F times 1.36 "V"\
$$
  Delta G = Delta G_1 + Delta G_2 &= -2 F times (1.63 "V" + 1.36 "V")\
  -4 F times E0 &= -2 F times (1.63 "V" + 1.36 "V")\
  E0 &= (1.63 "V" + 1.36 "V") / 2 = 1.5 "V" \
$

== Disproportionation

A disproportionation reaction is a type of redox reaction in which a single species of intermediate oxidation state, is both oxidized and reduced. For example, the reaction of chlorine with sodium hydroxide:

$
  ce("3 Cl2 +  6 OH^- --> 5 Cl^- + ClO3^- + 3H2O")\
$

This is composed of the following half-reactions:

$
  ce("Cl2 + 2e^- -> 2 Cl^-")\
  E0 = 1.36 V\
  ce("Cl2 + 12 OH^- -> 2 ClO3^- + 6 H2O + 10e^-")\
  E0 = -0.37 V\
$

Hence, the standard cell potential can be calculated as:

$
  2 Delta G = 5 Delta G_1 + Delta G_2\
  => 2 times (- 10 F E0cell) = 5 times (-2 F E0_1) + (-10 F E0_2)\
  => E0 = (1.36 "V" - 0.37 "V") / 2 = 0.495 "V"\
$

In general we can say, for a disproportionation reaction:

$
  E0 = (E0red + E0ox) / 2\
$

Thus, for disproportionation to be spontaneous, on the Latimer diagram, *the left half-reaction must have a lower standard reduction potential than the right half-reaction*.

Another example of a disproportionation is #ce("H2O2"), which disproportionates into #ce("H2O") and #ce("O2"). Its feasibility is clear from the Latimer diagram of oxygen.

= Motivation

Consider the Latimer diagram of Nitrogen in acidic conditions:

#latimer(
  species: ("NO3^-", "N2O4", "HNO2", "NO", "N2O", "N2"),
  os: (5, 4, 3, 2, 1, 0),
  pot: (0.803, 1.07, 0.996, 1.59, 1.77),
)

#latimer(species: ("N2", "NH3OH^+", "N2H5^+", "NH4^+"), os: (0, -1, -2, -3), pot: (-1.87, 1.41, 1.275))

Now, since potentials are not additive, let's try to find the free energy of each species instead. Consider the free energy of $ce("N2")$ to be 0.

Then, e.g. for $ce("N2O4")$, we have:

$
  G(ce("HNO2")) = Delta G \(ce("N2 -> HNO2")\) &= Delta G_1 + Delta G_2 + Delta G_3\
  &= - 1 F (-1.77) - 1 F (-1.59) - 1 F (-0.996)\
  &= - F (-1.77 - 1.59 - 0.996)\
  &= F (4.356)\
$

Similarly, if we find the free energy of each species, we get

#figure(
  table(columns: 9, align: center)[#ce("NO3^-")][#ce("N2O4")][#ce("HNO2")][#ce("NO")][#ce("N2O")][#ce("N2")][#ce("NH3OH^+")][#ce("N2H5^+")][#ce("NH4^+")][$6.229 F$][$5.426 F$][$4.356 F$][$3.36 F$][$1.77 F$][$0$][$1.87 F$][$0.46 F$][$-0.815 F$],
)


The above data gives a clear picture of the stability of the species. For example, $ce("NH4^+")$ is the most stable species, while $ce("NO3^-")$ is the least stable.

Now, if we would like to find $E0 \(ce("HNO2 -> N2")\)$, we can do so as follows:

$
  Delta G \(ce("HNO2 -> N2")\) = G \(ce("N2")\) - G \(ce("HNO2")\) = 0 - 4.356 F = -4.356 F\
  => -2 times F times E0 \(ce("HNO2 -> N2")\) = -4.356 F\
  => E0 \(ce("HNO2 -> N2")\) = 2.178 V\
$

Similarly we can find the standard potentials for other half-reactions:
$
  - n F E0("X" -> "Y") = G ("Y") - G ("X")\
  =>
  E0("X" -> "Y") =- 1 / F (G ("Y") - G ("X")) / (|N_Y - N_X|)\
$

where $N$ represents oxidation state, and $|N_Y - N_X|$ is the number of electrons transferred in the reduction half-reaction.


Consider the #E0red values for half reactions involving $ce("(N2, X)")$. Here, $Delta G = G(X)$. Then,

$
  - n F E0\(ce("N2 -> X")\) = G ("X")\
  => E0\(ce("N2 -> X")\) = - (G ("X")) / (|N_X| F)\
$

Now, if oxidation state of $X$ is negative, then it is a reduction half-reaction. So, $E0red = - frac(G(X), (-N_X) F) = frac(G(X), N_X F)$.

If the oxidation state of $X$ is positive, then it is an oxidation half-reaction. So, $E0ox = - frac(G(X), N_X F)$. $E0red = frac(G(X), N_X F)$

Notice that in either case, we get

$
  E0red = frac(G(X), N_X F)\
  => N_X E0red = frac(G(X), F)\
$

Thus, the product of the oxidation state and the standard reduction potential for the half reaction (involving elemental form of the species), is proportional to the free energy of the species, and indicates the stability of the species.

= Frost Diagrams

A Frost diagram is a plot between $N E0red$ vs $N$, where $N$ is the oxidation state of the species. It is made relative to the elemental form of the species.

For example, the Frost diagram of Nitrogen in acidic and basic conditions is shown below:

#figure(image("media/frost.png", width: 80%), caption: [Frost diagram for Nitrogen. (red - acidic, blue - basic)])

In this diagram, the height of each point shows the free energy of the species. Thus we can identify that $ce("NH4^+")$ is the most stable species, while $ce("NO3^-")$ is the least stable (in acidic conditions).

Furthurmore, *the slope of the line connecting two points is the standard reduction potential of the half-reaction between the two species*.

Here is the justification for the slope: Consider two species $X$ and $Y$ with oxidation states $N_X > N_Y$.
$
  Delta G\(ce("N2 -> Y")\) = Delta G\(ce("N2 -> X")\) + Delta G\(ce("X -> Y")\)\
  => |N_Y| E0\(ce("N2 -> Y")\) = |N_X| E0\(ce("N2 -> X")\) + (N_X - N_Y) E0\(ce("X -> Y")\)\
$

Here, notice that $|N_Y| E0\(ce("N2 -> Y")\)$ is the same as $- N_Y E0red_Y$. This is because:
- If $N_Y > 0$ then $ce("N2 -> Y")$ is an oxidation reaction and $E0red_Y$ will be negative of $E0\(ce("N2 -> Y")\)$
- If $N_Y < 0$ then $ce("N2 -> Y")$ is a reduction reaction and $E0red_Y$ will be equal to $E0\(ce("N2 -> Y")\)$

So on substituting, we get:

$
  => N_Y E0red_Y = N_X E0red_X + (N_Y - N_X) E0\(ce("X -> Y")\)\
  => #boxed[$ E0\(ce("X -> Y")\) = (N_Y E0red_Y - N_X E0red_X) / (N_Y - N_X)\ $]
$

Thus, the slope of the line connecting two points on the Frost diagram is the standard reduction potential of the half-reaction between the two species.

The steepness of a line is the measure of the tendency of the couple to react in the direction yielding the product having lower free energy.

From the Frost curve, we can also find species unstable to disproportionation, and species stable to comproportionation.

- A species is unstable to disproportionation, if its point lies below the line connecting the points of the species with its neighbouring species. For example, $ce("NH3OH^+")$ is unstable to disproportionation in acidic conditions.

- A species is stable to comproportionation, if its point lies above the line connecting the points of the species with its neighbouring species. For example, $ce("N2")$ is stable to comproportionation in acidic conditions.

The condition for disproportionation comes from the fact that since the #E0red for the oxidised neighbour must be lower than the #E0red for the reduced neighbour, thus the right slope must be less than the left one. (Note that order of the species is reversed in the Frost diagram as compared to the Latimer diagram) This implies that the point must lie below the line connecting the two points.


#align(center, line(length: 50%))

= References

- Frost, Arthur (1951). "Oxidation Potential–Free Energy Diagrams". Journal of the American Chemical Society. 73 (6): 2680–2682. doi:10.1021/ja01150a074 (https://pubs.acs.org/doi/abs/10.1021/ja01150a074)
- Shriver (2010). Inorganic Chemistry. W. H. Freeman & Co.
