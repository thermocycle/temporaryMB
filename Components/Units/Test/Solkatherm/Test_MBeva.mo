within Components.Units.Test.Solkatherm;
model Test_MBeva
parameter Integer N = 10;
  HeatExchangers.MovingBoundary.MBeva mBeva(
    rho_wall=8.93e3,
    U_SB=3000,
    Void=0.665,
    dVoid_dp=0,
    dVoid_dh=0,
    U_SH=3000,
    redeclare package Medium = ThermoCycle.Media.Solkatherm_CPSmooth,
    M_tot=69,
    c_wall=500,
    TwSB(start=100 + 273.15, displayUnit="K"),
    TwTP(start=100 + 273.15, displayUnit="K"),
    TwSH(start=100 + 273.15, displayUnit="K"),
    U_TP=3000,
    h_EX(start=254493),
    A=0.0000192,
    L=1042,
    L_SB(start=400),
    L_TP(start=600),
    p(start=888343))
    annotation (Placement(transformation(extent={{-26,-40},{20,-4}})));
  MovingBoundary.Test.DHT2MBHT dHT2MBHT1(
    N=N,
    Stot=16.18,
    Ltot=1042)
           annotation (Placement(transformation(
        origin={-4,42},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
    redeclare package Medium = ThermoCycle.Media.Solkatherm_CPSmooth,
    Mdot_0=0.3335,
    p=888343,
    T_0=356.26)
    annotation (Placement(transformation(extent={{-86,-54},{-66,-34}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium = ThermoCycle.Media.Solkatherm_CPSmooth,
                                                   p0=888343)
    annotation (Placement(transformation(extent={{66,-32},{86,-12}})));
  ThermoCycle.Components.FluidFlow.Pipes.Flow1DConst flow1DConst(
    N=N,
    V=0.02,
    Mdotnom=3.148,
    Unom=15000,
    Discretization=ThermoCycle.Functions.Enumerations.Discretizations.upwind_AllowFlowReversal,
    Tstart_inlet=398.15,
    Tstart_outlet=389.45)
    annotation (Placement(transformation(extent={{14,94},{-26,66}})));

  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    Mdot_0=3.148,
    T_0=398.15,
    cp=1907,
    rho=937.952)
    annotation (Placement(transformation(extent={{74,70},{54,90}})));
equation
  connect(dHT2MBHT1.mh,mBeva. MB_port) annotation (Line(
      points={{-4,32.2},{-4,6},{-1.85,6},{-1.85,-7.6}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, mBeva.InFlow) annotation (Line(
      points={{-67,-44},{-54,-44},{-54,-22.36},{-25.54,-22.36}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(mBeva.OutFlow, sinkP.flangeB) annotation (Line(
      points={{20,-22},{67.6,-22}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(flow1DConst.Wall_int, dHT2MBHT1.dHT) annotation (Line(
      points={{-6,73},{-3.9,73},{-3.9,52}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(sourceCdot.flange, flow1DConst.flange_Cdot) annotation (Line(
      points={{55.8,79.9},{34.9,79.9},{34.9,80},{14,80}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end Test_MBeva;
