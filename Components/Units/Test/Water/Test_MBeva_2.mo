within Components.Units.Test.Water;
model Test_MBeva_2
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
  HeatExchangers.MovingBoundary.MBeva mBeva(
    redeclare package Medium = ThermoCycle.Media.StandardWater,
    A=0.0314159,
    rho_wall=8.93e3,
    U_SB=3000,
    U_TP=10000,
    Void=0.665,
    dVoid_dp=0,
    dVoid_dh=0,
    U_SH=3000,
    L=1,
    c_wall=385,
    h_EX(start=3043000),
    L_SB(start=0.2),
    TwSB(start=510.97 + 50, displayUnit="K"),
    TwTP(start=548.79 + 21, displayUnit="K"),
    TwSH(start=585.97 + 35, displayUnit="K"),
    L_TP(start=0.4),
    M_tot=9.35E+01,
    p(start=6000000))
    annotation (Placement(transformation(extent={{-36,-50},{10,-14}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
    redeclare package Medium = ThermoCycle.Media.StandardWater,
    UseT=false,
    h_0=852450,
    Mdot_0=0.05,
    p=6000000)
    annotation (Placement(transformation(extent={{-80,-46},{-60,-26}})));
  MovingBoundary.Test.DHT2MBHT dHT2MBHT1(
    Ltot=1,
    Stot=0.725519132873375,
    N=Ntot)
           annotation (Placement(transformation(
        origin={-10,24},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  ThermoPower.Thermal.HeatSource1D heatSource1D(
    L=1,
    omega=1,
    N=Ntot)  annotation (Placement(transformation(extent={{-52,64},{-32,84}},
          rotation=0)));
  Modelica.Blocks.Sources.Constant Hin(k=852540)
    annotation (Placement(transformation(extent={{-104,-18},{-84,2}},
          rotation=0)));
  ThermoPower.Water.ValveLin valveLin(Kv=2*0.05/59e5, redeclare package Medium
      =        Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{56,-34},{76,-14}},
          rotation=0)));
  ThermoPower.Water.SinkP sinkP1(
                                redeclare package Medium =
        Modelica.Media.Water.StandardWater, p0=10000000000)
                        annotation (Placement(transformation(extent={{86,-34},{106,
            -14}},          rotation=0)));
  Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
    annotation (Placement(transformation(extent={{16,64},{32,74}},
                                                                 rotation=0)));
  Modelica.Blocks.Sources.Constant Pout(k=1e5)
    annotation (Placement(transformation(extent={{60,78},{80,98}}, rotation=
           0)));
  inner ThermoPower.System system(allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-82,40},{-62,60}})));
  Modelica.Blocks.Sources.Constant Phi_nom(k=phin)
    annotation (Placement(transformation(extent={{-78,84},{-62,94}},
          rotation=0)));
equation
  connect(sourceMdot.flangeB, mBeva.InFlow) annotation (Line(
      points={{-61,-36},{-59.27,-36},{-59.27,-32.36},{-35.54,-32.36}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(dHT2MBHT1.dHT, heatSource1D.wall)
                                           annotation (Line(points={{-9.9,34},
          {-10,34},{-10,46},{-12,46},{-12,58},{-42,58},{-42,71}},
                                    color={255,127,0}));
  connect(dHT2MBHT1.mh, mBeva.MB_port) annotation (Line(
      points={{-10,14.2},{-10,8},{-11.85,8},{-11.85,-17.6}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(Hin.y, sourceMdot.in_h) annotation (Line(
      points={{-83,-8},{-64,-8},{-64,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinkP1.flange, valveLin.outlet)
    annotation (Line(points={{86,-24},{80,-24},{76,-24}}));
  connect(mBeva.OutFlow, valveLin.inlet) annotation (Line(
      points={{10,-32},{16,-32},{16,-26},{22,-26},{22,-24},{56,-24}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Pout.y, sinkP1.in_p0) annotation (Line(
      points={{81,88},{90,88},{90,-15.2},{92,-15.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Cmd_nom.y, valveLin.cmd) annotation (Line(
      points={{32.8,69},{66,69},{66,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Phi_nom.y, heatSource1D.power) annotation (Line(
      points={{-61.2,89},{-40.6,89},{-40.6,78},{-42,78}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    experiment(StopTime=7000),
    __Dymola_experimentSetupOutput);
end Test_MBeva_2;
