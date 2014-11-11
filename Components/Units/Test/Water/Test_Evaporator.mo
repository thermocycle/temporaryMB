within Components.Units.Test.Water;
model Test_Evaporator
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot source_Cdot3_2(
    Mdot_0=2,
    T_0=653.15,
    cp=2046,
    rho=1000)
    annotation (Placement(transformation(extent={{58,32},{38,52}})));
  ThermoCycle.Components.Units.HeatExchangers.Hx1DConst eva(
    Mdotnom_sf=3.148,
    Mdotconst_wf=false,
    steadystate_h_wf=true,
    steadystate_T_wall=true,
    steadystate_T_sf=false,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    redeclare model Medium1HeatTransferModel =
        ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer.VaporQualityDependance,
    N=30,
    V_sf=0.02,
    V_wf=0.02,
    redeclare package Medium1 = CoolProp2Modelica.Media.WaterTPSI_FP,
    Unom_sf=10000,
    Unom_l=3000,
    Unom_tp=10000,
    Unom_v=3000,
    Mdotnom_wf=0.05,
    pstart_wf=6000000,
    Tstart_inlet_wf=503.15,
    Tstart_outlet_wf=718.15,
    Tstart_outlet_sf=718.15)
    annotation (Placement(transformation(extent={{-28,2},{8,40}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
    redeclare package Medium = CoolProp2Modelica.Media.WaterTPSI_FP,
    UseT=false,
    Mdot_0=0.05,
    p=6000000,
    T_0=356.26)
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Modelica.Blocks.Sources.Constant Hin(k=852540)
    annotation (Placement(transformation(extent={{-104,2},{-84,22}},
          rotation=0)));
  ThermoPower.Water.ValveLin valveLin(Kv=2*0.05/59e5, redeclare package Medium
      =        CoolProp2Modelica.Media.WaterTPSI_FP)
    annotation (Placement(transformation(extent={{50,-16},{70,4}},
          rotation=0)));
  ThermoPower.Water.SinkP sinkP1(
                                redeclare package Medium =
     CoolProp2Modelica.Media.WaterTPSI_FP, p0=10000000000)
                        annotation (Placement(transformation(extent={{80,-16},
            {100,4}},       rotation=0)));
  Modelica.Blocks.Sources.Constant Pout(k=1e5)
    annotation (Placement(transformation(extent={{114,14},{94,34}},rotation=
           0)));
  Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
    annotation (Placement(transformation(extent={{40,12},{56,22}},
                                                                 rotation=0)));
  inner ThermoPower.System system(allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-90,50},{-50,88}})));
equation
  connect(eva.inletSf, source_Cdot3_2.flange) annotation (Line(
      points={{8,30.5},{16,30.5},{16,30},{24,30},{24,41.9},{39.8,41.9}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, eva.inletWf) annotation (Line(
      points={{-71,-20},{-54,-20},{-54,10},{-42,10},{-42,11.5},{-28,11.5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Hin.y, sourceMdot.in_h) annotation (Line(
      points={{-83,12},{-74,12},{-74,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinkP1.flange,valveLin. outlet)
    annotation (Line(points={{80,-6},{74,-6},{70,-6}}));
  connect(Pout.y,sinkP1. in_p0) annotation (Line(
      points={{93,24},{84,24},{84,2.8},{86,2.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Cmd_nom.y,valveLin. cmd) annotation (Line(
      points={{56.8,17},{60,17},{60,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eva.outletWf, valveLin.inlet) annotation (Line(
      points={{8,11.5},{18,11.5},{18,10},{30,10},{30,-6},{50,-6}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end Test_Evaporator;
