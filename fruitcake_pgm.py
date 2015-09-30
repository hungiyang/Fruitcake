import daft


def draw():

    # Instantiate a PGM.
    pgm = daft.PGM([3.3, 3.0], origin=[0.3, 0.3], grid_unit=2.6, node_unit=1.3, observed_style="inner")

    # Model parameters:
    pgm.add_node(daft.Node("w", r"$w$", 0.8, 2.8))
    pgm.add_node(daft.Node("h", r"$h$", 1.8, 2.8))
    pgm.add_node(daft.Node("sigma", r"$\sigma$", 2.6, 2.2))
    pgm.add_node(daft.Node("Pbad", r"$P_{\rm bad}$", 1.8, 0.6))

    # Latent variable - BMI:
    pgm.add_node(daft.Node("BMI", r"${\rm BMI}$", 1.3, 2.2, fixed=True, offset=(20,-10)))

    # Data - obesity and height:
    pgm.add_node(daft.Node("bobs", r"$b^{\rm obs}_k$", 1.3, 1.4, observed=True))
    pgm.add_node(daft.Node("hobs", r"$h^{\rm obs}_k$", 2.3, 1.4, observed=True))

    # Add in the edges.
    pgm.add_edge("w", "BMI")
    pgm.add_edge("h", "BMI")
    pgm.add_edge("BMI", "bobs")
    pgm.add_edge("Pbad", "bobs")
    pgm.add_edge("Pbad", "hobs")
    pgm.add_edge("h", "hobs")
    pgm.add_edge("sigma", "hobs")

    # And a plate for the pixels
    pgm.add_plate(daft.Plate([0.5, 1.0, 2.7, 0.8], label=r"observers $k$", shift=-0.1))

    # Render and save.
    pgm.render()
    pgm.figure.savefig("fruitcake_pgm.png", dpi=300)

    return
