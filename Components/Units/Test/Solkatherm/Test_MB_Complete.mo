within Components.Units.Test.Solkatherm;
model Test_MB_Complete
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(
    UseT=false,
    h_0=852450,
    Mdot_0=0.3335,
    redeclare package Medium = ThermoCycle.Media.Solkatherm_CPSmooth,
    p=6000000)
    annotation (Placement(transformation(extent={{-122,-40},{-102,-20}})));
  HeatExchangers.MovingBoundary.MBeva_Complete mBeva_Complete(
    rho_wall=8.93e3,
    L_SB(start=0.2),
    Void=0.665,
    dVoid_dp=0,
    dVoid_dh=0,
    ETA=1,
    M_tot=69,
    c_wall=500,
    TwSB(start=116 + 273.15, displayUnit="K"),
    Tsf_SU_start=125 + 273.15,
    h_EX(start=254493),
    redeclare package Medium = ThermoCycle.Media.Solkatherm_CPSmooth,
    Mdotnom=0.3335,
    TwTP(start=116 + 273.15, displayUnit="K"),
    TwSH(start=116 + 273.15, displayUnit="K"),
    Usf=2000,
    U_SB=2000,
    U_TP=2000,
    U_SH=2000,
    L_TP(start=0.2),
    A=0.0000192,
    L=1000,
    p(start=888343),
    dTsf_start=283.15)
    annotation (Placement(transformation(extent={{-76,-30},{-28,18}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    Mdot_0=3.148,
    cp=1907,
    rho=937.952,
    T_0=398.15) annotation (Placement(transformation(extent={{-34,40},{-14,60}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(
    redeclare package Medium = ThermoCycle.Media.Solkatherm_CPSmooth,
    h=255110,
    p0=888343)
    annotation (Placement(transformation(extent={{68,-36},{88,-16}})));
  ORCNext.Components.PdropHP     pdropHP(
    UseHomotopy=false,
    constinit=false,
    use_rho_nom=true)
    annotation (Placement(transformation(extent={{10,-36},{30,-16}})));
equation
  connect(sourceMdot.flangeB,mBeva_Complete. InFlow) annotation (Line(
      points={{-103,-30},{-88,-30},{-88,-21.36},{-75.52,-21.36}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sourceCdot.flange,mBeva_Complete. InFlow_sf) annotation (Line(
      points={{-15.8,49.9},{-4,49.9},{-4,8.4},{-28,8.4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(mBeva_Complete.OutFlow, pdropHP.InFlow) annotation (Line(
      points={{-28,-21.36},{0,-21.36},{0,-26},{11,-26}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pdropHP.OutFlow, sinkP.flangeB) annotation (Line(
      points={{29,-26},{69.6,-26}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    experiment(StopTime=50, Tolerance=1e-007),
    __Dymola_experimentSetupOutput);
end Test_MB_Complete;
