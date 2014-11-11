within Components;
package Media
  package WaterCoolProp "MB - CoolProp model of water"
    extends ExternalMedia.Media.CoolPropMedium(
      mediumName = "Water",
      substanceNames = {"water|enable_TTSE=1|calc_transport=1"},
      ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.ph,
      AbsolutePressure(start=10e5),
      SpecificEnthalpy(start=2e5));
  end WaterCoolProp;

  package Therminol66CoolProp "MB - CoolProp model of Therminol 66"
    extends ExternalMedia.Media.CoolPropMedium(
      mediumName = "Therminol66",
      substanceNames = {"T66|enable_TTSE=1|calc_transport=1"},
      ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.pT);
  end Therminol66CoolProp;
end Media;
