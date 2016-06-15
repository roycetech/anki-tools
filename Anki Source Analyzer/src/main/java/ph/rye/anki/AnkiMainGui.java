/**
 *   Copyright 2016 Royce Remulla
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package ph.rye.anki;


import java.awt.EventQueue;
import java.awt.Window;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.logging.Level;
import java.util.logging.Logger;

import ph.rye.anki.model.AnkiService;
import ph.rye.anki.util.LatestFileFinder;
import ph.rye.anki.view.Constraint;
import ph.rye.anki.view.MenuBar;
import ph.rye.anki.view.PanelBottom;
import ph.rye.anki.view.PanelLeft;
import ph.rye.anki.view.PanelRight;


/**
 * @author royce
 */
public class AnkiMainGui extends javax.swing.JFrame {


    /** */
    private static final long serialVersionUID = 1L;


    private final transient AnkiService service = new AnkiService();


    private final transient MenuBar menuBar = new MenuBar(this, service);

    private final transient PanelLeft panelLeft = new PanelLeft(this, service);

    private final transient PanelRight panelRight =
            new PanelRight(this, service);

    private final transient PanelBottom panelBottom =
            new PanelBottom(this, service);

    /**
     * Creates new form AnkiMainGui
     */
    public AnkiMainGui() {

        AnkiMainGui.enableOSXFullscreen(this);

        initComponents();
    }

    /**
     * @param window
     */
    @SuppressWarnings({
            "unchecked",
            "rawtypes" })
    private static void enableOSXFullscreen(final Window window) {

        try {
            final Class util =
                    Class.forName("com.apple.eawt.FullScreenUtilities");

            final Class params[] = new Class[] {
                    Window.class,
                    Boolean.TYPE };

            final Method method =
                    util.getMethod("setWindowCanFullScreen", params);

            method.invoke(util, window, true);

        } catch (final ClassNotFoundException | IllegalAccessException
                | IllegalArgumentException | InvocationTargetException
                | NoSuchMethodException | SecurityException e1) {

            Logger.getLogger(AnkiMainGui.class.getName()).log(
                Level.WARNING,
                "OS X Fullscreen FAIL",
                e1);

        }
    }

    private final void initComponents() {

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setTitle("Anki Source Editor");
        getContentPane().setLayout(new java.awt.GridBagLayout());

        panelLeft.initComponents();

        getContentPane().add(
            panelLeft,
            new Constraint.Builder()
                .fill(java.awt.GridBagConstraints.BOTH)
                .weightx(1)
                .weighty(1)
                .insets(new java.awt.Insets(10, 10, 0, 10))
                .build());


        panelRight.initComponents();

        getContentPane().add(
            panelRight,
            new Constraint.Builder()
                .gridx(1)
                .gridy(0)
                .fill(java.awt.GridBagConstraints.VERTICAL)
                .anchor(java.awt.GridBagConstraints.EAST)
                .weighty(1)
                .insets(new java.awt.Insets(0, 0, 0, 10))
                .build());

        panelBottom.initComponents();

        getContentPane().add(
            panelBottom,
            new Constraint.Builder()
                .gridx(0)
                .gridy(1)
                .gridwidth(2)
                .fill(java.awt.GridBagConstraints.BOTH)
                .anchor(java.awt.GridBagConstraints.SOUTH)
                .weightx(1)
                .weighty(2)
                .insets(new java.awt.Insets(10, 10, 10, 10))
                .build());

        menuBar.initComponents();
        setJMenuBar(menuBar);

        pack();
    }

    /**
     * @param args the command line arguments
     */
    public static void main(final String args[]) {
        try {
            for (final javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager
                .getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (final ClassNotFoundException | InstantiationException
                | IllegalAccessException
                | javax.swing.UnsupportedLookAndFeelException ex) {
            Logger.getLogger(AnkiMainGui.class.getName()).log(
                Level.SEVERE,
                null,
                ex);
        }

        /* Create and display the form */
        EventQueue.invokeLater(() -> {
            final AnkiMainGui main = new AnkiMainGui();
            main.setLocationRelativeTo(null);
            main.setVisible(true);

            main.menuBar.selectFile(
                new LatestFileFinder("/Users/royce/DropBox/Documents/Reviewer")
                    .find());

        });
    }


    /**
     * @return the panelLeft
     */
    public PanelLeft getPanelLeft() {
        return panelLeft;
    }

    /**
     * @return the panelRight
     */
    public PanelRight getPanelRight() {
        return panelRight;
    }

    /**
     * @return the panelBottom
     */
    public PanelBottom getPanelBottom() {
        return panelBottom;
    }

    /** */
    public void setFileDirty() {
        if (getTitle().indexOf(" *") < 0) {
            setTitle(getTitle() + " *");
        }
    }

    /** */
    public void setFileClean() {
        setTitle(getTitle().replaceAll("\\s\\*", ""));
    }

    /** */
    public MenuBar getMainMenu() {
        return menuBar;
    }

}
