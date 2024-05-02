# Rules

1- The `subzone_id` on a `Junction` indicates which `Subzone` a `Pipe` is entering.
1- Every `Water Tank` is connected to one `Water Input` and one `Water Zone`.
2- `Water Tank`s and `Water Input`s level should be equal or lower to their capacity.
3- `Water Tank` and `Water Ouput` input pipes should be connected to a `Junction` in the other end.
4- `Water Input` every water output is connected to an outside zone
5- No two different zones can enter into one `Junction` (but many subzones can)


If any of this rules is broken, an error message should come along with the request that loaded the data.


# TODO

- Set conditions for well structured pipe system
- EXPLAIN ZONES AND SUBZONES FOR WATER INPUE ZONE AND ZONE
- MOCK LOG DATA