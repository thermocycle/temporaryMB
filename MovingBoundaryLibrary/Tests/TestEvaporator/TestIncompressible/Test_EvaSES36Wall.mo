within MovingBoundaryLibrary.Tests.TestEvaporator.TestIncompressible;
model Test_EvaSES36Wall
replaceable package Medium =
    ThermoCycle.Media.SES36_CP;

  parameter Modelica.SIunits.AbsolutePressure p_out = 60E5;
  parameter Modelica.SIunits.Temperature T_sf_su = 1000+273.15;
parameter Medium.ThermodynamicState stateOut= Medium.setState_pT(p_out,T_sf_su-100);
parameter Modelica.SIunits.SpecificEnthalpy h0 = Medium.specificEnthalpy(stateOut);
parameter Integer n=3;
parameter Boolean counterCurrent = true;

  Components.Evaporator.Incompressible.EvaGeneralInc evaGeneral(
    redeclare package Medium = Medium,
    Ltotal=66.6,
    AA=0.0007,
    YY=0.243,
    Mdotnom=0.3061,
    UnomSC=3000,
    UnomTP=8000,
    UnomSH=3000,
    hstartSC=8E4,
    hstartTP=2E5,
    hstartSH=256022,
    lstartSC=2,
    lstartTP=50,
    lstartSH=14.6,
    eps_NTU=false,
    pstart=810927)  annotation (Placement(transformation(extent={{-8,-58},{12,
            -38}})));
  Components.SecondaryFluid.SecondaryFluid secondaryFluid(
    n=n,
    Usf=1000,
    L_total=66.6,
    AA=0.0007,
    YY=0.243,
    eps_NTU=true,
    Tstart=398.15,
    DTstart=278.15)
                 annotation (Placement(transformation(extent={{-10,48},{10,68}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                        Medium,
    Mdot_0=0.3061,
    T_0=345.27)
    annotation (Placement(transformation(extent={{-72,-60},{-52,-40}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                      Medium, p0=
       810927)
    annotation (Placement(transformation(extent={{82,-60},{102,-40}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(
    Mdot_0=3.147,
    T_0=398.15,
    cp=1907,
    rho=937.952)
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  Components.Wall.wall wall3volumes(
    cp_w=500,
    L_total=66.6,
    M_w=69,
    n=3,
    TstartWall={393.15,393.15,393.15}) annotation (Placement(transformation(extent={{-10,0},{10,20}})));
initial equation
 //evaGeneral.volumeSH.h_b = h0;
der(evaGeneral.volumeSH.h_b) = 0;
    der(evaGeneral.volumeSC.ll) = 0;
    der(evaGeneral.volumeTP.ll) = 0;
equation
    /* If statement to allow parallel or counter current structure*/

 if counterCurrent then
connect( wall3volumes.QmbOut, secondaryFluid.mbIn[n:-1:1]);
else
  connect(wall3volumes.QmbOut, secondaryFluid.mbIn);
end if;

  connect(sourceCdot.flange, secondaryFluid.InFlow_sf) annotation (Line(
      points={{-21.8,89.9},{40,89.9},{40,58},{9,58}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(wall3volumes.QmbIn, evaGeneral.mbOut)
    annotation (Line(
      points={{-0.8,1},{-0.8,-6},{2,-6},{2,-39}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(sourceMdot.flangeB, evaGeneral.InFlow) annotation (Line(
      points={{-53,-50},{-32,-50},{-32,-47.8},{-8.2,-47.8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaGeneral.OutFlow, sinkP.flangeB) annotation (Line(
      points={{11.8,-47.8},{54,-47.8},{54,-50},{83.6,-50}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=15000),
    __Dymola_experimentSetupOutput);
end Test_EvaSES36Wall;
