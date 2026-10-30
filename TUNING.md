# Tuning notes

All numbers are L2 gas from snforge 0.59.0.

Hash-to-point on its own started at 1,424,880 gas. Removing the length check on every word brought it to 1,258,290. The output is the same, so we kept it.

Putting the tag into the salt to save one permutation only saved 1,291 gas. It would need a new version and new vectors, so we did not do it.

Dropping the salt range checks saved 6,660 gas. We kept the checks so salts stay normal 40 byte Falcon salts.

The full verify went from 5,181,117 to 5,013,399 mean, so about 5.0M.

Things we looked at and did not build:

Using the third Poseidon state element would break the random oracle argument and save only about 25k.

More than 15 words per felt is not possible without bias.

14 bit words would mean about 25% more work.

poseidon_hash_many gives no saving over the raw permutation.

The core has no Poseidon specific shortcut, since the coefficients have the same range as in SHAKE mode.
