within MovingBoundaryLibrary.Tests.TestEvaporator.TestIncompressible;
model Test_EvaWaterWall
replaceable package Medium =
     ExternalMedia.Examples.WaterCoolProp;

  parameter Modelica.SIunits.AbsolutePressure p_out = 60E5;
  parameter Modelica.SIunits.Temperature T_sf_su = 1000+273.15;
parameter Medium.ThermodynamicState stateOut= Medium.setState_pT(p_out,T_sf_su-100);
parameter Modelica.SIunits.SpecificEnthalpy h0 = Medium.specificEnthalpy(stateOut);
parameter Integer n=3;
parameter Boolean counterCurrent = true;
  Components.Evaporator.Incompressible.EvaGeneralInc evaGeneral(
    redeclare package Medium = Medium,
    hstartSC=7.7E5,
    hstartTP=2E6,
    hstartSH=3E6,
    lstartTP=175,
    lstartSH=150,
    lstartSC=50,
    YY=1.57,
    pstart=6000000) annotation (Placement(transformation(extent={{-12,-62},{8,
            -42}})));
  Components.SecondaryFluid.SecondaryFluid secondaryFluid(
    n=n,
    Usf=1000,
    AA=0.0019,
    YY=1.57,
    L_total=500) annotation (Placement(transformation(extent={{-10,48},{10,68}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot sourceMdot(redeclare
      package Medium =                                                                        Medium,
    Mdot_0=0.5,
    T_0=349.15)
    annotation (Placement(transformation(extent={{-72,-60},{-52,-40}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP sinkP(redeclare package
      Medium =                                                                      Medium, p0=6000000)
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot sourceCdot(Mdot_0=5, T_0=
        1273.15)
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  Components.Wall.wall3volumes wall3volumes(
    cp_w=500,
    L_total=500,
    M_w=80,
    TstartWall={513.15,513.15,673.15}) annotation (Placement(transformation(extent={{-10,-6},
            {10,14}})));
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
      points={{-0.8,-5},{-0.8,-6},{-2,-6},{-2,-43}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(sourceMdot.flangeB, evaGeneral.InFlow) annotation (Line(
      points={{-53,-50},{-36,-50},{-36,-51.8},{-12.2,-51.8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaGeneral.OutFlow, sinkP.flangeB) annotation (Line(
      points={{7.8,-51.8},{54,-51.8},{54,-50},{81.6,-50}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=15000),
    __Dymola_experimentSetupOutput);
end Test_EvaWaterWall;
