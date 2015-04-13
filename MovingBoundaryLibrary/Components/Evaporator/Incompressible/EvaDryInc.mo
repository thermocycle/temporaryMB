within MovingBoundaryLibrary.Components.Evaporator.Incompressible;
model EvaDryInc
 replaceable package Medium =
      ExternalMedia.Examples.WaterCoolProp constrainedby
    Modelica.Media.Interfaces.PartialMedium
                                           annotation (choicesAllMatching=true);
  Cells.OnePhaseInc volumeSH(
    redeclare final package Medium = Medium,
    pstart=pstart,
    Mdotnom=Mdotnom,
    AA=AA,
    alone=false,
    YY=YY,
    subcooled=false,
    hstart=hstartSH,
    lstart=lstartSH,
    Unom=UnomSH,
    Ltotal=Ltotal,
    eps_NTU=eps_NTU)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Cells.TwoPhase volumeTP(
    redeclare final package Medium = Medium,
    pstart=pstart,
    hstart=hstartTP,
    lstart=lstartTP,
    Mdotnom=Mdotnom,
    Unom=UnomTP,
    AA=AA,
    alone=false,
    YY=YY,
    Ltotal=Ltotal,
    Flooded=false,
    General=false,
    VoidFraction=VoidFraction,
    VoidF=VoidF)
    annotation (Placement(transformation(extent={{-44,-10},{-24,10}})));
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow(redeclare final package Medium =
               Medium)
    annotation (Placement(transformation(extent={{-112,-8},{-92,12}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlow(  redeclare final package Medium
      =                                                                           Medium)
    annotation (Placement(transformation(extent={{88,-8},{108,12}})));

import MovingBoundaryLibrary.Records;

/* Parameters */
final parameter Integer  nCV= 2;
parameter Modelica.SIunits.Area AA = 0.0019 "Channel cross section";
parameter Modelica.SIunits.Length YY "Channel perimeter";
parameter Modelica.SIunits.Length Ltotal=500
    "Total length of the heat exchanger";

parameter Boolean VoidFraction = true
    "Set to true to calculate the void fraction to false to keep it constant";
parameter Real VoidF = 0.8 "Constantat void fraction" annotation (Dialog(enable= not VoidFraction));
/* Heat transfer */
parameter Modelica.SIunits.MassFlowRate Mdotnom=0.5 "Nominal fluid flow rate"
                             annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer   UnomSH=2500 annotation (Dialog(group = "Heat transfer"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer    UnomTP=9000 annotation (Dialog(group = "Heat transfer"));
parameter Boolean eps_NTU = false "Set to true for eps-NTU heat transfer" annotation (Dialog(group = "Heat transfer"));

/* Initial values */
parameter Modelica.SIunits.Pressure pstart=6e6 "Fluid pressure start value"
    annotation (Dialog(tab="Initialization"));

parameter Medium.SpecificEnthalpy hstartSH=1E5 "SC: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Length lstartSH=1 "SC:Start value of length"
    annotation (Dialog(tab="Initialization"));
parameter Medium.SpecificEnthalpy hstartTP=1E5 "TP: Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
parameter Modelica.SIunits.Length lstartTP=1 "TP:Start value of length"
    annotation (Dialog(tab="Initialization"));

  Records.Mode mode[nCV];

  Interfaces.MbOut mbOut[nCV]
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));
equation
  //L = {volumeSC.ll,volumeTP.ll};
  //sum(L) = Ltotal;

  volumeSH.mode = mode[nCV-1];
  volumeTP.mode = mode[nCV];

  mode[nCV-1] = Constants.ModeCompound;
  mode[nCV] = Constants.ModeCompound;
  /* Geometric constraints */
  volumeSH.ll + volumeTP.ll = Ltotal;
  volumeTP.la = 0;
  volumeSH.la = volumeTP.lb;

initial equation
// der(volumeSH.ll) = 0;

equation

  connect(InFlow, volumeTP.inFlow) annotation (Line(
      points={{-102,2},{-74,2},{-74,0},{-44,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(volumeTP.outFlow,volumeSH. inFlow)
    annotation (Line(
      points={{-24,0.1},{8,0.1},{8,0},{40,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(volumeSH.outFlow,OutFlow)
    annotation (Line(
      points={{60,0.1},{76,0.1},{76,2},{98,2}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(volumeTP.mbOut, mbOut[1])
    annotation (Line(
      points={{-34,9},{-34,40},{0,40},{0,85}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(volumeSH.mbOut, mbOut[2])
    annotation (Line(
      points={{50,9},{52,9},{52,38},{0,38},{0,95}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end EvaDryInc;
