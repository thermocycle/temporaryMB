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
          points={{6.10623e-16,17},{6.10623e-16,8.5},{6.10623e-16,8.5},{
              6.10623e-16,0},{6.10623e-16,-17},{6.10623e-16,-17}},
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
        offset=450,
        startTime=0.1)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      WallSegmentCut wall(length=sine1.y)
        annotation (Placement(transformation(extent={{-10,6},{10,26}})));
      Modelica.Blocks.Sources.Sine sine1(
        amplitude=0.1,
        freqHz=3,
        offset=0.3,
        phase=0,
        startTime=0.1)
        annotation (Placement(transformation(extent={{20,40},{40,60}})));
      Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlow annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=-90,
            origin={0,-8})));

    Modelica.SIunits.Heat Q0;
    Modelica.SIunits.HeatFlowRate Q0_dot;
    Modelica.SIunits.HeatFlowRate Q1_dot;
    Modelica.SIunits.Velocity s1;
    constant Modelica.SIunits.Temperature Tzero = 273.15;

    equation
      Q0 = wall.m_wall*(wall.T_wall-Tzero)*wall.wallProperties.cp;
      Q0_dot = der(Q0);
      Q1_dot = wall.port_a.Q_flow + wall.port_b.Q_flow + Q0_dot;

      s1 = der(wall.length);

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
      annotation (Diagram(graphics), Documentation(info="<html>
<p><h4><font color=\"#008000\">Illutsration of the energy conservation problem</font></h4></p>
<p>The problem here is that the change in energy that is associated with the varying length does not appear in any of the equations. Simply plot Q0_dot and Q1_dot to see the imbalance. Q0_dot is the change of energy in the wall material and Q1_dot is the heat balance plus this change. Hence, Q1_dot should be zero at all times. </p>
</html>"));
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
              6.10623e-16,10.2},{6.10623e-16,10.2},{6.10623e-16,5.4}},
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
        phase=0,
        startTime=0.2,
        amplitude=0.5,
        offset=5.5,
        freqHz=0.1)
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
        width=1,
        redeclare
          Components.Units.HeatExchangers.MovingBoundary.Materials.AluminumWall
          wallProperties,
        s_ab=0.005,
        Tstart_wall=373.15)
        annotation (Placement(transformation(extent={{-10,8},{10,28}})));
      ThermoCycle.Components.FluidFlow.Reservoirs.SinkMdot sinkMdot(
        redeclare package Medium = Medium,
        Mdot_0=0.02,
        pstart=200000)
        annotation (Placement(transformation(extent={{60,-10},{80,10}})));
      ThermoCycle.Components.FluidFlow.Reservoirs.Source_pT source_pT(
        redeclare package Medium = Medium,
        T=473.15,
        p=200000)
        annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
      WallSegmentCut wall1(                        length=lengthGenerator.y,
        steadystate_T_wall=true,
        width=1,
        s_ab=0.002,
        redeclare
          Components.Units.HeatExchangers.MovingBoundary.Materials.DefaultWall
          wallProperties,
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
        Mdot_0=0.02,
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
          points={{6.10623e-16,15},{-3.36456e-22,10},{6.10623e-16,10},{
              6.10623e-16,5.4}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(source_pT.flangeB, flow1DimCut.inlet) annotation (Line(
          points={{-60.8,6.10623e-16},{-36,-3.36456e-22},{-36,6.10623e-16},{-10,
              6.10623e-16}},
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

    model FlowSegments_tester

    replaceable package Medium = ThermoCycle.Media.R245faCool (
    ThermoStates=Modelica.Media.Interfaces.PartialMedium.Choices.IndependentVariables.ph)
      constrainedby Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching = true);

      Modelica.Blocks.Sources.Sine lengthGenerator0(
        freqHz=3,
        amplitude=0.2,
        offset=0.9,
        startTime=0.2,
        phase=0)
        annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
      Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlow annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={-40,0})));
      Flow1DimCut ductB1(
        redeclare package Medium = Medium,
        diameter=0.01,
        Mdotnom=1,
        Unom_l=200,
        Unom_tp=2000,
        Unom_v=120,
        length=length0,
        pstart=200000,
        Tstart=473.15)
        annotation (Placement(transformation(extent={{-50,-60},{-30,-40}})));
      WallSegmentCut wall11(
        steadystate_T_wall=true,
        width=1,
        s_ab=0.002,
        length=length0,
        Tstart_wall=373.15)
        annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
      ThermoCycle.Components.FluidFlow.Reservoirs.SinkMdot hotOutlet(
        redeclare package Medium = Medium,
        Mdot_0=0.1,
        pstart=200000)
        annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
      ThermoCycle.Components.FluidFlow.Reservoirs.Source_pT hotInlet(
        redeclare package Medium = Medium,
        T=473.15,
        p=200000)
        annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
      WallSegmentCut wall12(
        steadystate_T_wall=true,
        width=1,
        s_ab=0.002,
        length=length0,
        Tstart_wall=373.15)
        annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
      Flow1DimCut ductA3(
        length=length0,
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
            origin={-40,50})));
      ThermoCycle.Components.FluidFlow.Reservoirs.SinkMdot coldOutlet(
        redeclare package Medium = Medium,
        Mdot_0=0.2,
        pstart=2000000)
        annotation (Placement(transformation(extent={{-60,40},{-80,60}})));
      ThermoCycle.Components.FluidFlow.Reservoirs.Source_pT coldInlet(
        redeclare package Medium = Medium,
        T=293.15,
        p=2000000)
        annotation (Placement(transformation(extent={{80,40},{60,60}})));
      Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlow1
                                                                    annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={0,0})));
      Flow1DimCut ductB2(
        redeclare package Medium = Medium,
        diameter=0.01,
        Mdotnom=1,
        Unom_l=200,
        Unom_tp=2000,
        Unom_v=120,
        length=length1,
        pstart=200000,
        Tstart=473.15)
        annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
      WallSegmentCut wall21(
        steadystate_T_wall=true,
        width=1,
        s_ab=0.002,
        length=length1,
        Tstart_wall=373.15)
        annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
      WallSegmentCut wall22(
        steadystate_T_wall=true,
        width=1,
        s_ab=0.002,
        length=length1,
        Tstart_wall=373.15)
        annotation (Placement(transformation(extent={{-10,20},{10,40}})));
      Flow1DimCut ductA2(
        redeclare package Medium = Medium,
        diameter=0.01,
        Mdotnom=1,
        Unom_l=200,
        Unom_tp=2000,
        Unom_v=120,
        length=length1,
        pstart=2000000,
        Tstart=293.15)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=180,
            origin={0,50})));
      Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlow2
                                                                    annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={40,0})));
      Flow1DimCut ductB3(
        redeclare package Medium = Medium,
        diameter=0.01,
        Mdotnom=1,
        Unom_l=200,
        Unom_tp=2000,
        Unom_v=120,
        length=length2,
        pstart=200000,
        Tstart=473.15)
        annotation (Placement(transformation(extent={{30,-60},{50,-40}})));
      WallSegmentCut wall31(
        steadystate_T_wall=true,
        width=1,
        s_ab=0.002,
        length=length2,
        Tstart_wall=373.15)
        annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
      WallSegmentCut wall32(
        steadystate_T_wall=true,
        width=1,
        s_ab=0.002,
        length=length2,
        Tstart_wall=373.15)
        annotation (Placement(transformation(extent={{30,20},{50,40}})));
      Flow1DimCut ductA1(
        redeclare package Medium = Medium,
        diameter=0.01,
        Mdotnom=1,
        Unom_l=200,
        Unom_tp=2000,
        Unom_v=120,
        length=length2,
        pstart=2000000,
        Tstart=293.15)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=180,
            origin={40,50})));
      Modelica.Blocks.Sources.Sine lengthGenerator1(
        freqHz=5,
        phase=0,
        offset=1.1,
        amplitude=0.3,
        startTime=0.2)
        annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

     Modelica.SIunits.Length totalLength;
     Modelica.SIunits.Length length0;
     Modelica.SIunits.Length length1;
     Modelica.SIunits.Length length2;

     Modelica.SIunits.Heat Q0;
     Modelica.SIunits.Heat Q1;
     Modelica.SIunits.Heat Q2;

      Modelica.Fluid.Sensors.Temperature temp12(redeclare package Medium =
            Medium)
        annotation (Placement(transformation(extent={{-60,60},{-52,66}})));
      Modelica.Fluid.Sensors.Temperature temp22(redeclare package Medium =
            Medium)
        annotation (Placement(transformation(extent={{-24,60},{-16,66}})));
      Modelica.Fluid.Sensors.Temperature temp32(redeclare package Medium =
            Medium)
        annotation (Placement(transformation(extent={{16,60},{24,66}})));
      Modelica.Fluid.Sensors.Temperature temp42(redeclare package Medium =
            Medium)
        annotation (Placement(transformation(extent={{54,60},{62,66}})));
      Modelica.Fluid.Sensors.Temperature temp11(redeclare package Medium =
            Medium)
        annotation (Placement(transformation(extent={{-60,-40},{-52,-34}})));
      Modelica.Fluid.Sensors.Temperature temp21(redeclare package Medium =
            Medium)
        annotation (Placement(transformation(extent={{-24,-40},{-16,-34}})));
      Modelica.Fluid.Sensors.Temperature temp31(redeclare package Medium =
            Medium)
        annotation (Placement(transformation(extent={{16,-40},{24,-34}})));
      Modelica.Fluid.Sensors.Temperature temp41(redeclare package Medium =
            Medium)
        annotation (Placement(transformation(extent={{52,-40},{60,-34}})));
    equation
      totalLength = 3;
      length0 = lengthGenerator0.y;
      length1 = lengthGenerator1.y;
      length2 = totalLength-length1-length0;

      Q0 = wall11.m_wall*wall11.T_wall*wall11.wallProperties.cp;
      Q1 = wall21.m_wall*wall21.T_wall*wall21.wallProperties.cp;
      Q2 = wall31.m_wall*wall31.T_wall*wall31.wallProperties.cp;

      connect(ductA3.Wall_int, wall12.port_a)      annotation (Line(
          points={{-40,44.6},{-40,33}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(wall12.port_b, heatFlow.port_b)
                                             annotation (Line(
          points={{-40,27},{-40,10}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(heatFlow.port_a, wall11.port_a)
                                            annotation (Line(
          points={{-40,-10},{-40,-27}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(wall11.port_b, ductB1.Wall_int)    annotation (Line(
          points={{-40,-33},{-40,-44.6}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(ductA2.Wall_int, wall22.port_a)      annotation (Line(
          points={{-1.61687e-16,44.6},{-1.61687e-16,38},{0,33},{6.10623e-16,33}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(wall22.port_b, heatFlow1.port_b)
                                              annotation (Line(
          points={{6.10623e-16,27},{6.10623e-16,22},{0,22},{0,10},{1.1119e-15,
              10}},
          color={191,0,0},
          smooth=Smooth.None));

      connect(heatFlow1.port_a, wall21.port_a)
                                              annotation (Line(
          points={{-1.12703e-16,-10},{-1.12703e-16,-18},{0,-27},{6.10623e-16,
              -27}},
          color={191,0,0},
          smooth=Smooth.None));

      connect(wall21.port_b, ductB2.Wall_int)      annotation (Line(
          points={{6.10623e-16,-33},{6.10623e-16,-36},{0,-36},{0,-44.6},{
              6.10623e-16,-44.6}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(ductA1.Wall_int, wall32.port_a)      annotation (Line(
          points={{40,44.6},{40,33}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(wall32.port_b, heatFlow2.port_b)
                                              annotation (Line(
          points={{40,27},{40,10}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(heatFlow2.port_a, wall31.port_a)
                                              annotation (Line(
          points={{40,-10},{40,-27}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(wall31.port_b, ductB3.Wall_int)      annotation (Line(
          points={{40,-33},{40,-44.6}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(coldInlet.flangeB, ductA1.inlet)        annotation (Line(
          points={{60.8,50},{50,50}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(ductA1.outlet, ductA2.inlet)             annotation (Line(
          points={{30,50.2},{20,50.2},{20,50},{10,50}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(ductA2.outlet, ductA3.inlet)             annotation (Line(
          points={{-10,50.2},{-20,50.2},{-20,50},{-30,50}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(hotInlet.flangeB, ductB1.inlet)       annotation (Line(
          points={{-60.8,-50},{-50,-50}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(ductB1.outlet, ductB2.inlet)            annotation (Line(
          points={{-30,-50.2},{-20,-50.2},{-20,-50},{-10,-50}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(ductB2.outlet, ductB3.inlet)             annotation (Line(
          points={{10,-50.2},{20,-50.2},{20,-50},{30,-50}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(ductB3.outlet, hotOutlet.flangeB)      annotation (Line(
          points={{50,-50.2},{56,-50.2},{56,-50},{60.2,-50}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(coldOutlet.flangeB, ductA3.outlet) annotation (Line(
          points={{-60.2,50},{-55.1,50},{-55.1,50.2},{-50,50.2}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(ductB1.inlet, temp11.port) annotation (Line(
          points={{-50,-50},{-56,-50},{-56,-40}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(ductB1.outlet, temp21.port) annotation (Line(
          points={{-30,-50.2},{-20,-50.2},{-20,-40}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(temp31.port, ductB3.inlet) annotation (Line(
          points={{20,-40},{20,-50},{30,-50}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(temp41.port, hotOutlet.flangeB) annotation (Line(
          points={{56,-40},{56,-50},{60.2,-50}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(temp42.port, ductA1.inlet) annotation (Line(
          points={{58,60},{58,50},{50,50}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(temp32.port, ductA1.outlet) annotation (Line(
          points={{20,60},{20,50.2},{30,50.2}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(temp22.port, ductA2.outlet) annotation (Line(
          points={{-20,60},{-20,50.2},{-10,50.2}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(temp12.port, ductA3.outlet) annotation (Line(
          points={{-56,60},{-56,50.2},{-50,50.2}},
          color={0,127,255},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end FlowSegments_tester;
  end Testers;
end Examples;
