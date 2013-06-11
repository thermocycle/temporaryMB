within Components.Units.HeatExchangers.MovingBoundary;
package Obsolete "Old models"
  model OneSegment
      replaceable package MediumA = Modelica.Media.Water.WaterIF97_ph constrainedby
      Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching=true);
      replaceable package MediumB = Modelica.Media.Air.DryAirNasa constrainedby
      Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching=true);

    BaseClasses.BaseFluidSegment sideAinlet(redeclare package Medium = MediumA,
        redeclare model HeatTransfer =
          Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.ConstantFlowHeatTransfer)
      annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
    BaseClasses.BaseFluidSegment sideBoutlet(redeclare package Medium = MediumB,
        redeclare model HeatTransfer =
          Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.ConstantFlowHeatTransfer)
                                 annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={-40,40})));
    BaseClasses.BaseWallSegment wallSegmentOne(
      s=baseWallProperties.s,
      rho_wall=baseWallProperties.rho,
      c_wall=baseWallProperties.cp,
      k_wall=baseWallProperties.lambda)
      annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
    replaceable
      Components.Units.HeatExchangers.MovingBoundary.Materials.AluminumWall
                          baseWallProperties constrainedby
      BaseClasses.BaseWallProperties
      annotation (choicesAllMatching=true,Placement(transformation(extent={{-30,10},{-10,30}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
          MediumB)
      annotation (Placement(transformation(extent={{90,30},{110,50}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium =
          MediumA)
      annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
          MediumB)
      annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium =
          MediumA)
      annotation (Placement(transformation(extent={{90,-50},{110,-30}})));

    replaceable model HeatTransferA1 =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.ConstantFlowHeatTransfer
      constrainedby
      Components.Units.HeatExchangers.MovingBoundary.BaseClasses.PartialHeatTransferCorrelation
      "Heat transfer side A"
        annotation (Placement(transformation(extent={{-54,62},{-36,82}})),choicesAllMatching=true);

        replaceable model HeatTransferB1 =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.ConstantFlowHeatTransfer
      constrainedby
      Components.Units.HeatExchangers.MovingBoundary.BaseClasses.PartialHeatTransferCorrelation
      "Heat transfer side B"
        annotation (Placement(transformation(extent={{-54,62},{-35,82}})),choicesAllMatching=true);

    replaceable
      Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.ConstantFlowHeatTransfer           HeatTransferA
      constrainedby BaseClasses.PartialHeatTransferCorrelation
      annotation (Placement(transformation(extent={{-50,60},{-30,80}})),choicesAllMatching=true);
    replaceable
      Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.ConstantFlowHeatTransfer           HeatTransferB
      constrainedby BaseClasses.PartialHeatTransferCorrelation
      annotation (Placement(transformation(extent={{-50,-80},{-30,-60}})),choicesAllMatching=true);
  equation
    connect(sideBoutlet.heatPorts, wallSegmentOne.heatPort_a)  annotation (Line(
        points={{-40.1,35.6},{-40.1,19.8},{-40,19.8},{-40,5}},
        color={127,0,0},
        smooth=Smooth.None));
    connect(wallSegmentOne.heatPort_b, sideAinlet.heatPorts)  annotation (Line(
        points={{-40,-5},{-40,-35.6},{-39.9,-35.6}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(sideAinlet.port_b, port_b1) annotation (Line(
        points={{-30,-40},{100,-40}},
        color={0,127,255},
        pattern=LinePattern.None,
        smooth=Smooth.None));
    connect(sideAinlet.port_a, port_a1) annotation (Line(
        points={{-50,-40},{-100,-40}},
        color={0,127,255},
        pattern=LinePattern.None,
        smooth=Smooth.None));
    connect(port_b, sideBoutlet.port_b) annotation (Line(
        points={{-100,40},{-50,40}},
        color={0,127,255},
        pattern=LinePattern.None,
        smooth=Smooth.None));
    connect(sideBoutlet.port_a, port_a) annotation (Line(
        points={{-30,40},{100,40}},
        color={0,127,255},
        pattern=LinePattern.None,
        smooth=Smooth.None));
    annotation (Diagram(graphics));
  end OneSegment;
end Obsolete;
