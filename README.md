# Self-organised forests

Despite the complexities behind forest fire propagations (differences in trees, landscapes, and temperature) we find forest-fires are scale-invariant, that is, forest fires exhibit a power-law dependence of frequency on burn area, there are many small fires and few large fires.
You might remember from lectures the ubiquity of scale-invariance within nature is due to self-organised criticality.

Per Bak one of the creators of this concept, introduced a forest fire model which they assumed to show self-organised critical behaviour.
Their forest fire model, a cellular automaton, defined on a 2-dimensional grid followed four simple rules.
1) Initially, each site is randomly assigned to be a tree, a burning tree or empty.
The system is then parallel updated according to the following rules:
2) A burning tree becomes an empty site in the next time-step;
3) an empty site grows a tree with probability `p`, and
4) a tree becomes a burning tree in the next time-step if at least one of its neighbours is burning.

Unfortunately, this system was not truly critical.
It required the addition of ‘lightning strikes’ to become self-organised critical.
Thus, the fifth rule 5) a tree becomes a burning tree during a time step with probability `f` if no neighbour is burning.
In this lab, we will build the simple forest fire model, and demonstrate it is self-organised and critical exhibiting self-similar behaviour.

## 1. Implementation

You will find a shell script `forestFireModel.m`, we will need to implement the five rules inside this script to make the forest-fire model.

1.	Find where it says Rule 1 in the script, here we need to implement the initial conditions: 1) Initially each site is randomly assigned to be a tree, a burning tree or empty. Hint: Define empty ground as 0, a tree as 1, and a burning tree as 2, using 3*rand we can map uniform distribution to 3 states and floor this for a uniform sampling of 0, 1 and 2
2.	Find Rule 2 in the script, we want to implement: 2) A burning tree becomes an empty site in the next time-step. We can do this indirectly by starting our state as all empty and mapping across the fires and trees from the previous time-step.
3.	Find Rule 3 in the script, we want to implement: 3) an empty site grows a tree with probability `p`. Hint we want to randomly grow trees with probability p only on the empty ground (=0).
4.	Find Rule 4 in the script, we want to implement: 4) a tree becomes a burning tree in the next time-step if at least one of its neighbours is burning. Here we first find all the fires from the previous time-step using this you should check if their neighbours are a tree (=1) and if so set this tree on fire (=2).
5.	Finally, find Rule 5 in the script, we want to implement: 5) a tree becomes a burning tree during a time step with probability `f` if no neighbour is burning. Similar to above we want to randomly alight trees (=1) with probability `f`.

Within this model, an important criterion is that the lightning strikes at a rate `f`<<`p`, in this case, even though we parallel update, the burning of a cluster can be thought of as instantaneous, as long as `p` -> 0.
Thus, the critical conditions are that `f`<<`p`<<1, and this can be physically interpreted as a separation of timescales, as the time in which a forest cluster burns down is much shorter than the time in which a tree grows, which again is much shorter than the time between two lightning occurrences.
Consider the timescales these phenomena occur within nature.
Discuss in your group, do you believe this is a valid model for explaining the self-similarity of forest fires in nature?

```matlab
posID = c>0;
posID(1) = 0;
```

Now, we can plot our histogram using:
```matlab
loglog(x(posID),c(posID)/(sum(c(posID))),'x')
xlabel(‘Fire area (trees)’)
ylabel(‘PDF’)
```


# REFERENCES

* Bak, P, Chen K., and Tang, C, 1990, [A forest-fire model and some thoughts on turbulence](https://www.sciencedirect.com/science/article/pii/037596019090451S), Physics Letters A, 147(5-6), 297-300.
* Drossel, B and Schwabl F, 1992, Self Organized Critical Forest-Fire model
Phys. Rev. Lett. 69, 1629 (1992).
