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

import java.awt.GridBagLayout;

import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextArea;

import ph.rye.anki.AnkiMainGui;
import ph.rye.anki.model.AnkiService;

/**
 * @author royce
 *
 */
public class PanelLeft extends JPanel {


    /** */
    private static final long serialVersionUID = 656112677535078290L;


    private final transient AnkiMainGui parent;

    private final transient AnkiService service;


    private final JTextArea textArea = new JTextArea();;
    private final JTable tblCardTag = new JTable();
    private final JScrollPane scrollPaneText = new JScrollPane();;
    private final JScrollPane scrollPaneCardTag = new JScrollPane();;


    /** */
    private final JButton btnApply = new JButton();;


    public PanelLeft(final AnkiMainGui parent, final AnkiService service) {
        this.parent = parent;
        this.service = service;
    }


    public void initComponents() {

        setBorder(
            new javax.swing.border.SoftBevelBorder(
                javax.swing.border.BevelBorder.RAISED));

        setMaximumSize(new java.awt.Dimension(2147483647, 218));
        setLayout(new GridBagLayout());

        btnApply.setText("Apply");
        btnApply.setEnabled(false);
        btnApply.setHorizontalAlignment(javax.swing.SwingConstants.RIGHT);
        btnApply.setHorizontalTextPosition(javax.swing.SwingConstants.RIGHT);

        btnApply.addActionListener((event) -> btnApplyActionPerformed());

        add(
            btnApply,
            new Constraint.Builder()
                .gridx(0)
                .gridy(0)
                .anchor(java.awt.GridBagConstraints.EAST)
                .build());

        scrollPaneText.setMaximumSize(new java.awt.Dimension(32767, 80));
        scrollPaneText.setVisible(true);

        textArea.setEditable(false);
        textArea.setColumns(20);
        textArea.setLineWrap(true);
        textArea.setRows(5);
        textArea.setWrapStyleWord(true);
        scrollPaneText.setViewportView(textArea);

        add(
            scrollPaneText,
            new Constraint.Builder()
                .gridx(0)
                .gridy(1)
                .fill(java.awt.GridBagConstraints.BOTH)
                .anchor(java.awt.GridBagConstraints.NORTH)
                .weightx(1)
                .weighty(1)
                .build());

        scrollPaneCardTag.setVisible(true);

        add(
            scrollPaneCardTag,
            new Constraint.Builder()
                .gridx(0)
                .gridy(1)
                .fill(java.awt.GridBagConstraints.BOTH)
                .weightx(1)
                .weighty(1)
                .build());


        tblCardTag.setModel(service.getCardTagModel());
        tblCardTag.setColumnSelectionAllowed(false);
        tblCardTag.setRowSelectionAllowed(false);
        tblCardTag.setShowGrid(true);

        tblCardTag.getModel().addTableModelListener(e -> {
            btnApply.setEnabled(true);
        });

        scrollPaneCardTag.setViewportView(tblCardTag);
    }

    private void btnApplyActionPerformed() {

        final JTable tblCard = parent.getPanelBottom().getTblCard();

        final int selectedRow = tblCard.getSelectedRow();

        final int selectedCol = tblCard.getSelectedColumn();


        if (selectedRow > -1 && selectedCol > -1) {

            scrollPaneText.setVisible(selectedCol < 2);
            scrollPaneCardTag.setVisible(selectedCol >= 2);


            final int modelRow = tblCard.convertRowIndexToModel(selectedRow);
            tblCard.getSelectedRow();

            if (selectedCol == 0) {

                service.getCardModel().getCardAt(modelRow).setFront(
                    textArea.getText());

            } else if (selectedCol == 1) {

                service.getCardModel().getCardAt(modelRow).setBack(
                    textArea.getText());

            } else if (selectedCol == 2) {
                service.updateCardTable(modelRow, selectedCol);
            }

            service.getCardModel().fireTableCellUpdated(modelRow, selectedCol);
            btnApply.setEnabled(false);
            textArea.setEditable(false);
        }

        parent.setFileDirty();

    }


    /**
     * @return the btnApply
     */
    public JButton getBtnApply() {
        return btnApply;
    }


    /**
     * @return the textArea
     */
    public JTextArea getTextArea() {
        return textArea;
    }


    /**
     * @return the scrollPaneText
     */
    public JScrollPane getScrollPaneText() {
        return scrollPaneText;
    }


    /**
     * @return the scrollPaneCardTag
     */
    public JScrollPane getScrollPaneCardTag() {
        return scrollPaneCardTag;
    }


    /**
     * @return the tblCardTag
     */
    public JTable getTblCardTag() {
        return tblCardTag;
    }

}
