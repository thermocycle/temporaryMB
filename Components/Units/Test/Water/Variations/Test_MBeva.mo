within Components.Units.Test.Water.Variations;
model Test_MBeva
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
    p=6000000)
    annotation (Placement(transformation(extent={{-82,-44},{-62,-24}})));
  MovingBoundary.Test.DHT2MBHT dHT2MBHT1(
    Ltot=1,
    Stot=0.725519132873375,
    N=Ntot)
           annotation (Placement(transformation(
        origin={-14,32},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  ThermoPower.Thermal.HeatSource1D heatSource1D(
    L=1,
    omega=1,
    N=Ntot)  annotation (Placement(transformation(extent={{-28,74},{-8,94}},
          rotation=0)));
  Modelica.Blocks.Math.Add3 add3_3 annotation (Placement(transformation(
          extent={{-72,106},{-58,116}},
                                      rotation=0)));
  Modelica.Blocks.Sources.Constant Hin(k=852540)
    annotation (Placement(transformation(extent={{-126,36},{-106,56}},
          rotation=0)));
  Modelica.Blocks.Sources.Ramp W_var_1(
    offset=0,
    height=wn*wp,
    startTime=wt,
    duration=tr)  annotation (Placement(transformation(extent={{-166,8},{-150,18}},
                        rotation=0)));
  Modelica.Blocks.Sources.Ramp W_var_2(
    height=-wp*wn,
    startTime=wt + 800,
    duration=tr)        annotation (Placement(transformation(extent={{-166,-12},
            {-150,-2}},       rotation=0)));
  Modelica.Blocks.Math.Add3 add3_2 annotation (Placement(transformation(
          extent={{-128,-4},{-114,6}},  rotation=0)));
  Modelica.Blocks.Sources.Constant W_nom(k=wn)
    annotation (Placement(transformation(extent={{-166,26},{-150,36}},
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
  Modelica.Blocks.Sources.Ramp Cmd_var_1(
    height=cmdn*cmdp,
    offset=0,
    startTime=cmdt,
    duration=tr)    annotation (Placement(transformation(extent={{16,46},{32,56}},
                     rotation=0)));
  Modelica.Blocks.Sources.Ramp Cmd_var_2(
    height=-cmdp*cmdn,
    startTime=cmdt + 600,
    duration=tr)          annotation (Placement(transformation(extent={{16,26},{
            32,36}},        rotation=0)));
  Modelica.Blocks.Math.Add3 add3_1 annotation (Placement(transformation(
          extent={{50,38},{64,48}},   rotation=0)));
  Modelica.Blocks.Sources.Constant Cmd_nom(k=cmdn)
    annotation (Placement(transformation(extent={{16,64},{32,74}},
                                                                 rotation=0)));
  Modelica.Blocks.Sources.Constant Pout(k=1e5)
    annotation (Placement(transformation(extent={{60,78},{80,98}}, rotation=
           0)));
  inner ThermoPower.System system(allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Ramp Phi_var_1(
    offset=0,
    height=phin*phip,
    startTime=phit,
    duration=tr)    annotation (Placement(transformation(extent={{-134,104},{
            -118,114}},
                      rotation=0)));
  Modelica.Blocks.Sources.Ramp Phi_var_2(
    height=-phip*phin,
    startTime=phit + 600,
    duration=tr)          annotation (Placement(transformation(extent={{-124,78},
            {-108,88}},    rotation=0)));
  Modelica.Blocks.Sources.Constant Phi_nom(k=phin)
    annotation (Placement(transformation(extent={{-150,118},{-134,128}},
          rotation=0)));
equation
  connect(sourceMdot.flangeB, mBeva.InFlow) annotation (Line(
      points={{-63,-34},{-59.27,-34},{-59.27,-32.36},{-35.54,-32.36}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(add3_3.y,heatSource1D. power) annotation (Line(points={{-57.3,111},{-18,
          111},{-18,88}},     color={0,0,127}));
  connect(dHT2MBHT1.dHT, heatSource1D.wall)
                                           annotation (Line(points={{-13.9,
          42},{-18,42},{-18,81}},   color={255,127,0}));
  connect(dHT2MBHT1.mh, mBeva.MB_port) annotation (Line(
      points={{-14,22.2},{-14,8},{-11.85,8},{-11.85,-17.6}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(W_var_2.y,add3_2. u3) annotation (Line(points={{-149.2,-7},{-139.6,-7},
          {-139.6,-3},{-129.4,-3}},            color={0,0,127}));
  connect(W_var_1.y,add3_2. u2) annotation (Line(points={{-149.2,13},{-140,13},{
          -140,1},{-129.4,1}},         color={0,0,127}));
  connect(W_nom.y,add3_2. u1) annotation (Line(points={{-149.2,31},{-129.4,31},{
          -129.4,5}},       color={0,0,127}));
  connect(Hin.y, sourceMdot.in_h) annotation (Line(
      points={{-105,46},{-108,46},{-108,44},{-66,44},{-66,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add3_2.y, sourceMdot.in_Mdot) annotation (Line(
      points={{-113.3,1},{-78,1},{-78,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinkP1.flange, valveLin.outlet)
    annotation (Line(points={{86,-24},{80,-24},{76,-24}}));
  connect(mBeva.OutFlow, valveLin.inlet) annotation (Line(
      points={{10,-32},{16,-32},{16,-26},{22,-26},{22,-24},{56,-24}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Cmd_var_2.y,add3_1. u3) annotation (Line(points={{32.8,31},{42.4,31},{
          42.4,39},{48.6,39}},         color={0,0,127}));
  connect(Cmd_var_1.y,add3_1. u2) annotation (Line(points={{32.8,51},{42,51},{42,
          43},{48.6,43}},       color={0,0,127}));
  connect(add3_1.y, valveLin.cmd) annotation (Line(points={{64.7,43},{66,43},{66,
          -16}},          color={0,0,127}));
  connect(Cmd_nom.y,add3_1. u1) annotation (Line(points={{32.8,69},{48.6,69},{48.6,
          47}},        color={0,0,127}));
  connect(Pout.y, sinkP1.in_p0) annotation (Line(
      points={{81,88},{90,88},{90,-15.2},{92,-15.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Phi_var_2.y,add3_3. u3) annotation (Line(points={{-107.2,83},{-97.6,
          83},{-97.6,107},{-73.4,107}},     color={0,0,127}));
  connect(Phi_var_1.y,add3_3. u2) annotation (Line(points={{-117.2,109},{-98,
          109},{-98,111},{-73.4,111}},
                                    color={0,0,127}));
  connect(Phi_nom.y, add3_3.u1) annotation (Line(points={{-133.2,123},{-73.4,
          123},{-73.4,115}},
                           color={0,0,127}));
  annotation (Diagram(graphics),
    experiment(StopTime=7000),
    __Dymola_experimentSetupOutput);
end Test_MBeva;
