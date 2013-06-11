within Components.Units.HeatExchangers.MovingBoundary.BaseClasses;
model BaseSegment
    replaceable package MediumA = Modelica.Media.Water.WaterIF97_ph constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching=true);
    replaceable package MediumB = Modelica.Media.Air.DryAirNasa constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching=true);

  BaseFluidSegment sideAinlet(redeclare package Medium = MediumA)
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  BaseFluidSegment sideBoutlet(redeclare package Medium = MediumB)
                               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-40,40})));
  BaseWallSegment wallSegmentOne(
    s=baseWallProperties.s,
    rho_wall=baseWallProperties.rho,
    c_wall=baseWallProperties.cp,
    k_wall=baseWallProperties.lambda)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  BaseWallSegment wallSegmentTwo(
    s=baseWallProperties.s,
    rho_wall=baseWallProperties.rho,
    c_wall=baseWallProperties.cp,
    k_wall=baseWallProperties.lambda)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  BaseWallSegment wallSegmentThree(
    s=baseWallProperties.s,
    rho_wall=baseWallProperties.rho,
    c_wall=baseWallProperties.cp,
    k_wall=baseWallProperties.lambda)
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  BaseFluidSegment sideBcentre(redeclare package Medium = MediumB)
                               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={0,40})));
  BaseFluidSegment sideBinlet(redeclare package Medium = MediumB)
                              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,40})));
  BaseFluidSegment sideAcentre(redeclare package Medium = MediumA)
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  BaseFluidSegment sideAoutlet(redeclare package Medium = MediumA)
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  replaceable BaseWallProperties baseWallProperties
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
equation
  connect(sideBoutlet.heatPorts, wallSegmentOne.heatPort_a)  annotation (Line(
      points={{-40.1,35.6},{-40.1,19.8},{-40,19.8},{-40,5}},
      color={127,0,0},
      smooth=Smooth.None));
  connect(wallSegmentOne.heatPort_b, sideAinlet.heatPorts)  annotation (Line(
      points={{-40,-5},{-40,-35.6},{-39.9,-35.6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wallSegmentTwo.heatPort_b, sideAcentre.heatPorts)   annotation (Line(
      points={{6.66134e-16,-5},{6.66134e-16,-20.5},{0.1,-20.5},{0.1,-35.6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sideBcentre.heatPorts, wallSegmentTwo.heatPort_a)   annotation (Line(
      points={{-0.1,35.6},{-0.1,20.8},{6.66134e-16,20.8},{6.66134e-16,5}},
      color={127,0,0},
      smooth=Smooth.None));
  connect(sideBinlet.heatPorts,wallSegmentThree. heatPort_a) annotation (Line(
      points={{39.9,35.6},{39.9,19.8},{40,19.8},{40,5}},
      color={127,0,0},
      smooth=Smooth.None));
  connect(wallSegmentThree.heatPort_b, sideAoutlet.heatPorts) annotation (Line(
      points={{40,-5},{40,-35.6},{40.1,-35.6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sideBoutlet.port_a, sideBcentre.port_b) annotation (Line(
      points={{-30,40},{-10,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sideBcentre.port_a, sideBinlet.port_b) annotation (Line(
      points={{10,40},{30,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sideAinlet.port_b, sideAcentre.port_a) annotation (Line(
      points={{-30,-40},{-10,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sideAcentre.port_b, sideAoutlet.port_a) annotation (Line(
      points={{10,-40},{30,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b1, sideAinlet.port_a) annotation (Line(
      points={{-100,-40},{-50,-40}},
      color={0,127,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(sideBoutlet.port_b, port_a) annotation (Line(
      points={{-50,40},{-100,40}},
      color={0,127,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(sideBinlet.port_a, port_b) annotation (Line(
      points={{50,40},{100,40}},
      color={0,127,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(sideAoutlet.port_b, port_a1) annotation (Line(
      points={{50,-40},{100,-40}},
      color={0,127,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end BaseSegment;
