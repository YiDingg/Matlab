function stc_Ic_Vce_Vbe_3D = MyDataProcessor_BJT_Data88_IcVceVbe_3D(data, name, R_Ib, unit_Ic, unit_Ib)
    stc_Ic_Vce_Vbe_3D = MyDataProcessor_BJT_Data1_IcVceIb_3D(data, name, R_Ib, unit_Ic, unit_Ib);
    stc_Ic_Vce_Vbe_3D.label_left.y.String = "Base-Emitter Voltage $V_{BE}$ (V)";
    stc_Ic_Vce_Vbe_3D.label_right.y.String = "Base-Emitter Voltage $V_{BE}$ (V)";
end