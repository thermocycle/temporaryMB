within Components.Units.Test.Water.ComparisonFV;
model Test_FV
parameter Real tr = 30 "nominal ramp duration";
parameter Integer Ntot = 10 "nominal number of nodes";
parameter Real phin = 150954 "nominal external heat flux";
parameter Real phip = 0.05 "percent varation of external heat flux";
parameter Real phit = 4000 "time of first variation of external heat flux";
parameter Real wn = 0.05 "nominal inlet mass flow rate";
parameter Real wp = 0.05 "percent varation of inlet mass flow rate";
parameter Real wt = 2000 "time of first variation of inlet mass flow rate";
parameter Real cmdn = 0.5 "nominal valve's command";
parameter Real cmdp = 0.05 "percent varation of valve's command";
parameter Real cmdt = 800 "time of first variation of valve's command";
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
    UseT=false,
    h_0=852450,
    Mdot_0=0.05,
    redeclare package Medium = CoolProp2Modelica.Media.WaterTPSI_FP,
    p=6000000)
    annotation (Placement(transformation(extent={{-86,-50},{-66,-30}})));
  Modelica.Blocks.Sources.Constant Hin(k=852540)
    annotation (Placement(transformation(extent={{-100,-16},{-80,4}},
          rotation=0)));
  ThermoPower.Water.ValveLin valveLin(Kv=2*0.05/59e5, redeclare package Medium
      =        CoolProp2Modelica.Media.WaterTPSI_FP)
    annotation (Placement(transformation(extent={{60,-44},{80,-24}},
          rotation=0)));
  ThermoPower.Water.SinkP sinkP1(
                                redeclare package Medium =
     CoolProp2Modelica.Media.WaterTPSI_FP, p0=10000000000)
                        annotation (Placement(transformation(extent={{90,-44},{110,
            -24}},          rotation=0)));
  Modelica.Blocks.Sources.Constant Pout(k=1e5)
    annotation (Placement(transformation(extent={{128,14},{108,34}},
                                                                   rotation=
           0)));
  inner ThermoPower.System system(allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-86,56},{-66,76}})));
 ThermoCycle.Components.Units.HeatExchangers.Hx1DConst FV(
    redeclare package Medium1 = CoolProp2Modelica.Media.WaterTPSI_FP,
    Unom_sf=20000,
    Unom_l=3000,
    Unom_tp=10000,
    Unom_v=3000,
    M_wall=9.35E+01,
    c_wall=385,
    Mdotnom_sf=2,
    Mdotnom_wf=0.05,
    Tstart_inlet_wf=510.97 + 50,
    Tstart_outlet_wf=585.97 + 35,
    Tstart_inlet_sf=360 + 273.15,
    Tstart_outlet_sf=350 + 273.15,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    V_sf=0.03142,
    V_wf=0.03142,
    A_sf=0.6283,
    A_wf=0.6283,
    pstart_wf=6000000)
    annotation (Placement(transformation(extent={{-38,-44},{10,4}})));

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    rho=1000,
    Mdot_0=2,
    cp=2046,
    T_0=653.15) annotation (Placement(transformation(extent={{2,30},{22,50}})));
  Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
    annotation (Placement(transformation(extent={{26,74},{42,84}},
                                                                 rotation=0)));
equation
  connect(Hin.y, sourceMdot.in_h) annotation (Line(
      points={{-79,-6},{-70,-6},{-70,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinkP1.flange, valveLin.outlet)
    annotation (Line(points={{90,-34},{84,-34},{80,-34}}));
  connect(Pout.y, sinkP1.in_p0) annotation (Line(
      points={{107,24},{94,24},{94,-25.2},{96,-25.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Cmd_nom.y, valveLin.cmd) annotation (Line(
      points={{42.8,79},{70,79},{70,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, FV.inletWf) annotation (Line(
      points={{-67,-40},{-50,-40},{-50,-32},{-38,-32}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceCdot.flange, FV.inletSf) annotation (Line(
      points={{20.2,39.9},{26,39.9},{26,-8},{10,-8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FV.outletWf, valveLin.inlet) annotation (Line(
      points={{10,-32},{28,-32},{28,-34},{60,-34}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=true),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
            100}})),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end Test_FV;
