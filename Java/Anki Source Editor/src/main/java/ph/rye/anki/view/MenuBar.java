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
package ph.rye.anki.view;

import java.io.File;
import java.io.IOException;

import javax.swing.JFileChooser;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.filechooser.FileFilter;

import ph.rye.anki.AnkiMainGui;
import ph.rye.anki.model.AnkiService;

/**
 * @author royce
 *
 */
public class MenuBar extends JMenuBar {


    /** */
    private static final long serialVersionUID = -2667573788830181344L;


    private static final String SEP_TITLE = " - ";


    private final transient AnkiService service;


    private final transient AnkiMainGui parent;

    private transient JFileChooser fileChooser;


    private final transient JMenu mnuFile = new JMenu();
    private final transient JMenuItem mnuOpen = new JMenuItem();
    private final transient JMenuItem mnuSaveAs = new JMenuItem();
    private final transient JMenuItem mnuSave = new JMenuItem();
    private final transient JMenuItem mnuExport = new JMenuItem();
    private final transient JMenuItem mnuExit = new JMenuItem();


    public MenuBar(final AnkiMainGui parent, final AnkiService service) {
        this.parent = parent;
        this.service = service;
    }

    @SuppressWarnings("PMD.DoNotCallSystemExit")
    public void initComponents() {
        mnuFile.setText("File");

        mnuOpen.setAccelerator(
            javax.swing.KeyStroke.getKeyStroke(
                java.awt.event.KeyEvent.VK_O,
                java.awt.event.InputEvent.META_MASK));

        mnuOpen.setText("Open...");
        mnuOpen.addActionListener(evt -> mnuOpenActionPerformed());
        mnuFile.add(mnuOpen);

        mnuSave.setAccelerator(
            javax.swing.KeyStroke.getKeyStroke(
                java.awt.event.KeyEvent.VK_S,
                java.awt.event.InputEvent.META_MASK));

        mnuSave.setText("Save");
        mnuSave.setEnabled(false);
        mnuSave.addActionListener(event -> mnuSavePerformed());
        mnuFile.add(mnuSave);

        mnuSaveAs.setText("Save As...");
        mnuSaveAs.setEnabled(false);
        mnuFile.add(mnuSaveAs);

        mnuExport.setAccelerator(
            javax.swing.KeyStroke.getKeyStroke(
                java.awt.event.KeyEvent.VK_E,
                java.awt.event.InputEvent.META_MASK));
        mnuExport.setText("Export");
        mnuExport.setEnabled(false);
        mnuFile.add(mnuExport);

        mnuExit.setAccelerator(
            javax.swing.KeyStroke.getKeyStroke(
                java.awt.event.KeyEvent.VK_Q,
                java.awt.event.InputEvent.META_MASK));
        mnuExit.setText("Quit");
        mnuExit.addActionListener(event -> System.exit(0));
        mnuFile.add(mnuExit);

        add(mnuFile);
    }

    private void mnuSavePerformed() {
        parent.setFileClean();
        try {
            service.saveToFile();
        } catch (final IOException e) {
            JOptionPane.showMessageDialog(
                parent,
                "Could not save file!",
                "Save Error",
                JOptionPane.ERROR_MESSAGE);
        }
    }

    private void mnuOpenActionPerformed() {
        if (fileChooser == null) {
            fileChooser = new JFileChooser();
            fileChooser.setCurrentDirectory(
                new File("/Users/royce/DropBox/Documents/Memorize/"));
            fileChooser.setFileFilter(new FileFilter() {
                @Override
                public boolean accept(final File pathname) {
                    return pathname.getName().endsWith(".txt")
                            && pathname.isFile() || pathname.isDirectory();
                }

                @Override
                public String getDescription() {
                    return "Text Files";
                }
            });
        }

        final int returnVal = fileChooser.showOpenDialog(this);
        if (returnVal == JFileChooser.APPROVE_OPTION) {
            final File file = fileChooser.getSelectedFile();

            String appTitle;
            final int sepIndex = parent.getTitle().indexOf(SEP_TITLE);
            if (sepIndex > -1) {
                appTitle = parent.getTitle().substring(0, sepIndex);
            } else {
                appTitle = parent.getTitle();
            }

            parent.setTitle(appTitle + SEP_TITLE + file.getName());
            service.openFile(file);

            mnuSaveAs.setEnabled(true);
            mnuExport.setEnabled(true);
            parent.getPanelLeft().setApplyButtonEnabled(false);
            parent.getPanelLeft().getTextArea().setEditable(false);
            parent.getPanelLeft().getTextArea().setText("");
            //            parent.getPanelLeft().getScrollPaneText().setVisible(true);
            //            parent.getPanelLeft().getScrollPaneCardTag().setVisible(false);
            parent.getPanelBottom().refreshLabelText();
        }

    }

    /**
     *
     */
    public void enableSave() {
        mnuSave.setEnabled(true);
    }


}
