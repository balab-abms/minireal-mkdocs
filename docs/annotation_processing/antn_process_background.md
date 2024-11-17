---
title: Annotation Processing Background
summary: Introductory and Background infromatoin on Annotation Processing.
authors:
    - Duguma Yeshitla
date: 2024-11-10
---

# Background on Anntation Processing
## Introduction
Annotation processing plays a key role in the utilization of the MiniReal system.
It helps to generate the `Simulation Launcher` class when the project is compiled 
based on the respective simulation code implementation of the User. This class is:

* Used an an entry point for running the simulaiton jar file. The MiniReal system
looks for this class when trying to run the simulation jar file.
* Accepts the values for simulation parameters at run time from the MiniReal system
UI.
* Sends the charting values to the Message broker by invoking the correct method.

## Details of MiniReal Annotations
The custome Annotations and the respective processor built for the MiniReal system
is published on Maven Central. ([MiniReal Annotation Processing Library](
    https://central.sonatype.com/artifact/io.github.panderior/minireal-annotation))

The following table shows the purpose and scope of the annotations.

| Annotation | Parameters | Target     | Retention | Purpose      | Return Type |
|-----------|------------|------------|-----------|---------------|----------------|
| SimModel  | none       | Class      | Source    | To designate the Simulation Model class for annotation processing. Only one class can have this annotation. | Not applicable |
| SimAgent  | none       | Class      | Source    | To designate the Simulation Agent class for annotation processing. | Not applicable |
| SimChart  | name       | Method     | Source    | To identify a method for visualizing simulation data on a chart. | An integer summarizing the cumulative data of agents for a single simulation cycle. |
| SimParam  | value      | Parameter  | Source    | To define the parameters that the simulation model uses during execution.  | Not applicable |
