---
title: Simulation parameter annotation usage
summary: Information on Simulation parameter annotation usage
authors:
    - Duguma Yeshitla
date: 2024-11-10
---

# Simluation parameter Annotation usage
The `@SimParam` annotation can be used to specify the simulation model parameters
that will be recieved at runtime. The MiniReal system will pickup the list of
simulation parameters and show them on the UI. The values inserted by the User on
the UI will be fed to the simulation on runtime.

This annotation should be defined for arguments placed in the constructor of the
`Model` class.

The `@SimParam` annotation takes one argument for its self, which is the default value
for the parameter it is binded to. If no value is provided to the simulation model at
runtime, this default value is used to initialize the model parameter.

* The key for this argument is named `value` and it takes a `String` object.
* Later on the `String` value is casted to the correct type with respect to the simulation
parameter.

```java title="Model.java"
import org.simreal.annotation.*;
import sim.engine.SimState;

@SimModel
public class Model extends SimState  {
	
    // rest of code

	private int population;

    // class constructor
	public Model(
        @SimParam(value = "500") int population,
        @SimParam(value = "100") int wealth
    ) {
		super(System.currentTimeMillis());
		this.population = population;
		createAgents(wealth);
	}

    // rest of code
}
```