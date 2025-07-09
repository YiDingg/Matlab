function MyDataProcessor_BJT_AllData_figExport(stc_fig)
    MyExport_pdf(stc_fig.stc_Ic_Vce_Ib_big.num1.fig, 'stc_Ic_Vce_Ib_big')

    MyExport_pdf_modal(stc_fig.stc_Ic_Vce_Ib_3D.fig, 'stc_Ic_Vce_Ib_3D')  % 用 modal 以防颜色丢失

    MyExport_pdf(stc_fig.stc_Ic_Vce_Ib.num1.fig, 'stc_Ic_Vce_Ib')
    MyExport_pdf(stc_fig.stc_Ib_Vce_Ib.num1.fig, 'stc_Ib_Vce_Ib')
    MyExport_pdf(stc_fig.stc_rO_Ic_Ib.num1.fig, 'stc_rO_Ic_Ib')
    MyExport_pdf(stc_fig.stc_Beta_Vce_Ib.num1.fig, 'stc_Beta_Vce_Ib')

    MyExport_pdf(stc_fig.stc_Vsat_Ic.fig, 'stc_Vsat_Ic')

    MyExport_pdf(stc_fig.stc_Ic_Vce_Vbe.num1.fig, 'stc_Ic_Vce_Vbe')
    MyExport_pdf(stc_fig.stc_Ib_Vce_Vbe.num1.fig, 'stc_Ib_Vce_Vbe')
    MyExport_pdf(stc_fig.stc_Beta_Vce_Vbe.num1.fig, 'stc_Beta_Vce_Vbe')

    MyExport_pdf_modal(stc_fig.stc_Ic_Vce_Vbe_3D.fig, 'stc_Ic_Vce_Vbe_3D')  % 用 modal 以防颜色丢失

    MyExport_pdf(stc_fig.stc_Ic_Vbe_Vce.num1.fig, 'stc_Ic_Vbe_Vce')
    MyExport_pdf(stc_fig.stc_gm_Ic_Vce.num1.fig, 'stc_gm_Ic_Vce')
    MyExport_pdf(stc_fig.stc_gm_Vbe_Vce.num1.fig, 'stc_gm_Vbe_Vce')
    MyExport_pdf(stc_fig.stc_Beta_Vbe_Vce.num1.fig, 'stc_Beta_Vbe_Vce')
    MyExport_pdf(stc_fig.stc_Beta_Ic_Vce.num1.fig, 'stc_Beta_Ic_Vce')
    MyExport_pdf(stc_fig.stc_rpi_Ic_Vce.num1.fig, 'stc_rpi_Ic_Vce')
    MyExport_pdf(stc_fig.stc_rpi_Vbe_Vce.num1.fig, 'stc_rpi_Vbe_Vce')
end