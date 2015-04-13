within MovingBoundaryLibrary.Tests.TestEvaporator.TestDry;
model Test_DryCdotWall
  replaceable package Medium =
      ExternalMedia.Examples.WaterCoolProp;
  Components.Evaporator.EvaDry evaDry(
    redeclare package Medium = Medium,
    YY=1.57,
    hstartSH=3E6,
    lstartSH=450,
    lstartTP=50,
    hstartTP=2.1E6,
    pstart=6000000) annotation (Placement(transformation(extent={{-26,-100},{28,-60}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceMdot
    sourceMdot(redeclare package Medium = Medium,Mdot_0=0.5,
    T_0=548.735)
               annotation (Placement(
        transformation(extent={{-94,-88},
            {-74,-68}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SinkP
    sinkP(redeclare package Medium = Medium,
    h=3.E6,
    p0=6000000)
          annotation (Placement(transformation(
          extent={{76,-86},{96,-66}})));
  Components.SecondaryFluid.SecondaryFluid secondaryFluidCdot(
    Usf=1000,
    AA=0.0019,
    YY=1.57,
    L_total=500,
    n=n,
    Tstart=1473.15,
    DTstart=323.15) annotation (Placement(transformation(extent={{-20,36},{20,64}})));
  ThermoCycle.Components.FluidFlow.Reservoirs.SourceCdot
    sourceCdot(
    Mdot_0=55,
    T_0=1273.15,
    cp=4000)   annotation (Placement(
        transformation(extent={{38,70},{58,90}})));

      parameter Integer n=2;
parameter Boolean counterCurrent = true;
  Components.Wall.wall2volumes wall2volumesCdot(
    cp_w=500,
    L_total=500,
    M_w=90,
    TstartWall={573.15,573.15}) annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
equation

  /* If statement to allow parallel or counter current structure*/
if counterCurrent then
connect( wall2volumesCdot.QmbOut, secondaryFluidCdot.mbIn[n:-1:1]);
else
  connect(wall2volumesCdot.QmbOut, secondaryFluidCdot.mbIn);
end if;
  connect(sourceCdot.flange, secondaryFluidCdot.InFlow_sf)
    annotation (Line(
      points={{56.2,79.9},{66,79.9},{66,50},{18,50}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(wall2volumesCdot.QmbIn, evaDry.mbOut)
    annotation (Line(
      points={{-0.8,-29},{-0.8,-62},{1,-62}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(sourceMdot.flangeB, evaDry.InFlow) annotation (Line(
      points={{-75,-78},{-56,-78},{-56,-79.6},{-26.54,-79.6}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(evaDry.OutFlow, sinkP.flangeB) annotation (Line(
      points={{27.46,-79.6},{56,-79.6},{56,-76},{77.6,-76}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                               graphics));
end Test_DryCdotWall;
