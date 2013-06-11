within Components.Units.HeatExchangers.MovingBoundary;
package Examples "Examples for how to use the components from this package"
  extends Modelica.Icons.ExamplesPackage;
  package Testers "Tests for the single components from the package"
  extends Modelica.Icons.Package;

    model WallSegmentL_tester
      WallSegmentL steel(redeclare
          Components.Units.HeatExchangers.MovingBoundary.Materials.DefaultWall
          wallProperties, s_ab=0.015)
        annotation (Placement(transformation(extent={{-10,10},{10,30}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature cold(T(displayUnit=
             "K") = 350)
        annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
      WallSegmentL alu(redeclare
          Components.Units.HeatExchangers.MovingBoundary.Materials.AluminumWall
          wallProperties, s_ab=0.015)
        annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature hot
        annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
      Modelica.Blocks.Sources.Sine sine(
        amplitude=50,
        freqHz=2,
        offset=450)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
    equation
      connect(steel.port_b, alu.port_a) annotation (Line(
          points={{6.10623e-16,17},{6.10623e-16,-17}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(alu.port_b, cold.port) annotation (Line(
          points={{6.10623e-16,-23},{6.10623e-16,-30},{-20,-30}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(hot.port, steel.port_a)                   annotation (Line(
          points={{-20,30},{0,30},{0,23},{6.10623e-16,23}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(sine.y, hot.T)                   annotation (Line(
          points={{-59,50},{-52,50},{-52,30},{-42,30}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end WallSegmentL_tester;

    model WallSegmentCut_tester

      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature cold(T(displayUnit=
             "K") = 350)
        annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature hot
        annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
      Modelica.Blocks.Sources.Sine sine(
        amplitude=50,
        freqHz=2,
        offset=450)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      WallSegmentCut wall(length=sine1.y)
        annotation (Placement(transformation(extent={{-10,6},{10,26}})));
      Modelica.Blocks.Sources.Sine sine1(
        amplitude=0.1,
        freqHz=3,
        phase=1.5707963267949,
        offset=0.3)
        annotation (Placement(transformation(extent={{20,40},{40,60}})));
      Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlow annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={0,-8})));
    equation
      connect(sine.y, hot.T)                   annotation (Line(
          points={{-59,50},{-52,50},{-52,30},{-42,30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(hot.port, wall.port_a) annotation (Line(
          points={{-20,30},{6.10623e-16,30},{6.10623e-16,19}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(wall.port_b, heatFlow.port_a) annotation (Line(
          points={{6.10623e-16,13},{6.10623e-16,7.5},{2.44753e-15,7.5},{
              2.44753e-15,2}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(heatFlow.port_b, cold.port) annotation (Line(
          points={{-1.22629e-15,-18},{0,-18},{0,-30},{-20,-30}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end WallSegmentCut_tester;

    model WallSegmentCutFlow_tester

    replaceable package Medium = ThermoCycle.Media.R245faCool (
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph)
      constrainedby Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching = true);

      Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                                                             cold
        annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
      Modelica.Blocks.Sources.Sine sine(
        freqHz=2,
        offset=350,
        amplitude=0.1)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.Sine lengthGenerator(
        freqHz=3,
        offset=0.3,
        amplitude=0.05,
        phase=1.5707963267949)
        annotation (Placement(transformation(extent={{20,60},{40,80}})));
      Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlow annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={0,40})));
      Flow1DimCut flow1DimCut(
        length=lengthGenerator.y,
        redeclare package Medium = Medium,
        diameter=0.01,
        Mdotnom=1,
        Unom_l=200,
        Unom_tp=2000,
        Unom_v=120,
        pstart=200000,
        Tstart=473.15)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
      WallSegmentCut wall(                         length=lengthGenerator.y,
        Tstart_wall=373.15,
        steadystate_T_wall=true)
        annotation (Placement(transformation(extent={{-10,8},{10,28}})));
      ThermoCycle.Components.FluidFlow.Reservoirs.SinkMdot sinkMdot(
        redeclare package Medium = Medium,
        Mdot_0=0.1,
        pstart=200000)
        annotation (Placement(transformation(extent={{60,-10},{80,10}})));
      ThermoCycle.Components.FluidFlow.Reservoirs.Source_pT source_pT(
        redeclare package Medium = Medium,
        T=473.15,
        p=200000)
        annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    equation

      connect(heatFlow.port_b, cold.port) annotation (Line(
          points={{1.1119e-15,50},{-20,50}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(sine.y, cold.T) annotation (Line(
          points={{-59,50},{-42,50}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(heatFlow.port_a, wall.port_a) annotation (Line(
          points={{-1.12703e-16,30},{6.10623e-16,30},{6.10623e-16,21}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(wall.port_b, flow1DimCut.Wall_int) annotation (Line(
          points={{6.10623e-16,15},{6.10623e-16,12.6},{6.10623e-16,12.6},{
              6.10623e-16,10.2},{6.10623e-16,5.4},{6.10623e-16,5.4}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(source_pT.flangeB, flow1DimCut.inlet) annotation (Line(
          points={{-60.8,6.10623e-16},{-35.4,6.10623e-16},{-35.4,6.10623e-16},{
              -10,6.10623e-16}},
          color={0,0,255},
          smooth=Smooth.None));

      connect(flow1DimCut.outlet, sinkMdot.flangeB) annotation (Line(
          points={{10,-0.2},{36,-0.2},{36,6.10623e-16},{60.2,6.10623e-16}},
          color={0,127,255},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end WallSegmentCutFlow_tester;

    model WallSegmentCut2Flow_tester

    replaceable package Medium = ThermoCycle.Media.R245faCool (
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph)
      constrainedby Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching = true);

      Modelica.Blocks.Sources.Sine lengthGenerator(
        freqHz=3,
        amplitude=0.1,
        phase=1.5707963267949,
        offset=0.5)
        annotation (Placement(transformation(extent={{-40,-54},{-20,-34}})));
      Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlow annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={0,40})));
      Flow1DimCut flow1DimCut(
        length=lengthGenerator.y,
        redeclare package Medium = Medium,
        diameter=0.01,
        Mdotnom=1,
        Unom_l=200,
        Unom_tp=2000,
        Unom_v=120,
        pstart=200000,
        Tstart=473.15)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
      WallSegmentCut wall(                         length=lengthGenerator.y,
        steadystate_T_wall=true,
        s_ab=0.002,
        width=1,
        Tstart_wall=373.15)
        annotation (Placement(transformation(extent={{-10,8},{10,28}})));
      ThermoCycle.Components.FluidFlow.Reservoirs.SinkMdot sinkMdot(
        redeclare package Medium = Medium,
        Mdot_0=0.1,
        pstart=200000)
        annotation (Placement(transformation(extent={{60,-10},{80,10}})));
      ThermoCycle.Components.FluidFlow.Reservoirs.Source_pT source_pT(
        redeclare package Medium = Medium,
        T=473.15,
        p=200000)
        annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
      WallSegmentCut wall1(                        length=lengthGenerator.y,
        steadystate_T_wall=true,
        s_ab=0.002,
        width=1,
        Tstart_wall=373.15)
        annotation (Placement(transformation(extent={{-10,54},{10,74}})));
      Flow1DimCut flow1DimCut1(
        length=lengthGenerator.y,
        redeclare package Medium = Medium,
        diameter=0.01,
        Mdotnom=1,
        Unom_l=200,
        Unom_tp=2000,
        Unom_v=120,
        pstart=2000000,
        Tstart=293.15)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=180,
            origin={0,86})));
      ThermoCycle.Components.FluidFlow.Reservoirs.SinkMdot sinkMdot1(
        redeclare package Medium = Medium,
        Mdot_0=0.2,
        pstart=2000000)
        annotation (Placement(transformation(extent={{-50,78},{-70,98}})));
      ThermoCycle.Components.FluidFlow.Reservoirs.Source_pT source_pT1(
        redeclare package Medium = Medium,
        T=293.15,
        p=2000000)
        annotation (Placement(transformation(extent={{72,74},{52,94}})));
    equation


      connect(heatFlow.port_a, wall.port_a) annotation (Line(
          points={{-1.12703e-16,30},{6.10623e-16,30},{6.10623e-16,21}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(wall.port_b, flow1DimCut.Wall_int) annotation (Line(
          points={{6.10623e-16,15},{6.10623e-16,12.6},{6.10623e-16,12.6},{
              6.10623e-16,10.2},{6.10623e-16,10.2},{6.10623e-16,5.4}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(source_pT.flangeB, flow1DimCut.inlet) annotation (Line(
          points={{-60.8,6.10623e-16},{-48.1,6.10623e-16},{-48.1,6.10623e-16},{
              -35.4,6.10623e-16},{-35.4,6.10623e-16},{-10,6.10623e-16}},
          color={0,0,255},
          smooth=Smooth.None));

      connect(flow1DimCut.outlet, sinkMdot.flangeB) annotation (Line(
          points={{10,-0.2},{36,-0.2},{36,6.10623e-16},{60.2,6.10623e-16}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(wall1.port_b, heatFlow.port_b) annotation (Line(
          points={{6.10623e-16,61},{6.10623e-16,55.5},{1.1119e-15,55.5},{
              1.1119e-15,50}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(flow1DimCut1.Wall_int, wall1.port_a) annotation (Line(
          points={{-1.61687e-16,80.6},{-1.61687e-16,73.3},{6.10623e-16,73.3},{
              6.10623e-16,67}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(sinkMdot1.flangeB, flow1DimCut1.outlet) annotation (Line(
          points={{-50.2,88},{-32,88},{-32,86},{-10,86},{-10,86.2}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(source_pT1.flangeB, flow1DimCut1.inlet) annotation (Line(
          points={{52.8,84},{32,84},{32,86},{10,86}},
          color={0,0,255},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end WallSegmentCut2Flow_tester;
  end Testers;
end Examples;
