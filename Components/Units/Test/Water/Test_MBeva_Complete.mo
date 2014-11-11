within Components.Units.Test.Water;
model Test_MBeva_Complete
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
    annotation (Placement(transformation(extent={{132,30},{112,50}},
                                                                   rotation=
           0)));
  inner ThermoPower.System system(allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-100,40},{-60,78}})));
  HeatExchangers.MovingBoundary.MBeva_Complete mBeva_Complete(
    A=0.0314159,
    L=1,
    M_tot=9.35E+01,
    c_wall=385,
    rho_wall=8.93e3,
    TwSB(start=510.97 + 50, displayUnit="K"),
    TwTP(start=548.79 + 21, displayUnit="K"),
    TwSH(start=585.97 + 35, displayUnit="K"),
    Tsf_SU_start=360 + 273.15,
    U_SB=3000,
    U_TP=10000,
    U_SH=3000,
    L_SB(start=0.2),
    L_TP(start=0.4),
    Void=0.665,
    dVoid_dp=0,
    dVoid_dh=0,
    redeclare package Medium = CoolProp2Modelica.Media.WaterTPSI_FP,
    ETA=1,
    Usf=10000,
    p(start=6000000),
    dTsf_start=313.15,
    h_EX(start=2043000))
    annotation (Placement(transformation(extent={{-38,-42},{10,6}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    rho=1000,
    Mdot_0=2,
    cp=2046,
    T_0=653.15) annotation (Placement(transformation(extent={{-16,28},{4,48}})));
  Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
    annotation (Placement(transformation(extent={{46,-10},{62,0}},
                                                                 rotation=0)));
equation
  connect(Hin.y, sourceMdot.in_h) annotation (Line(
      points={{-79,-6},{-70,-6},{-70,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinkP1.flange, valveLin.outlet)
    annotation (Line(points={{90,-34},{84,-34},{80,-34}}));
  connect(Pout.y, sinkP1.in_p0) annotation (Line(
      points={{111,40},{94,40},{94,-25.2},{96,-25.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, mBeva_Complete.InFlow) annotation (Line(
      points={{-67,-40},{-52,-40},{-52,-33.36},{-37.52,-33.36}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(mBeva_Complete.OutFlow, valveLin.inlet) annotation (Line(
      points={{10,-33.36},{36,-33.36},{36,-34},{60,-34}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceCdot.flange, mBeva_Complete.InFlow_sf) annotation (Line(
      points={{2.2,37.9},{20,37.9},{20,-3.6},{10,-3.6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Cmd_nom.y, valveLin.cmd) annotation (Line(
      points={{62.8,-5},{70,-5},{70,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=true),
                      graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
            100}})),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput);
end Test_MBeva_Complete;
