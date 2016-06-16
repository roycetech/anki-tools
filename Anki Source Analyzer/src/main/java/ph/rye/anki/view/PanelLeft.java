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

import java.awt.Dimension;
import java.awt.GridBagLayout;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;

import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextArea;
import javax.swing.border.BevelBorder;
import javax.swing.border.SoftBevelBorder;

import ph.rye.anki.AnkiMainGui;
import ph.rye.anki.model.AnkiService;
import ph.rye.anki.model.Card;
import ph.rye.anki.model.Tag;
import ph.rye.anki.model.TagModel;
import ph.rye.common.loop.Iter;

/**
 * @author royce
 *
 */
public class PanelLeft extends JPanel {


    /** */
    private static final long serialVersionUID = 1L;


    private final transient AnkiMainGui parent;
    private final transient AnkiService service;


    private final JTextArea textArea = new JTextArea();;
    private final JTable tblCardTag = new JTable();
    private final JScrollPane scrollPaneText = new JScrollPane();;
    private final JScrollPane scrollPaneCardTag = new JScrollPane();;


    /** */
    private final transient JButton btnApply = new JButton();;


    public PanelLeft(final AnkiMainGui parent, final AnkiService service) {
        this.parent = parent;
        this.service = service;
    }


    public void initComponents() {

        setBorder(new SoftBevelBorder(BevelBorder.RAISED));

        setMaximumSize(new Dimension(2147483647, 218));
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
                .gridwidth(2)
                .anchor(java.awt.GridBagConstraints.EAST)
                .build());

        scrollPaneText.setMaximumSize(new Dimension(32767, 80));

        textArea.setEnabled(false);
        textArea.setColumns(20);
        textArea.setLineWrap(true);
        textArea.setRows(5);
        textArea.setWrapStyleWord(true);
        textArea.addKeyListener(new KeyAdapter() {
            @Override
            public void keyTyped(final KeyEvent event) {
                parent.getPanelBottom().setFrontCardValue(
                    textArea.getText().substring(0, textArea.getCaretPosition())
                            + event.getKeyChar() + textArea.getText().substring(
                                textArea.getCaretPosition()));
                parent.setFileDirty();
                parent.getMainMenu().enableSave();
            }

        });
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
        scrollPaneCardTag.setMinimumSize(new Dimension(150, Integer.MAX_VALUE));
        scrollPaneCardTag
            .setPreferredSize(new Dimension(300, Integer.MAX_VALUE));
        scrollPaneCardTag.setMaximumSize(new Dimension(600, Integer.MAX_VALUE));

        add(
            scrollPaneCardTag,
            new Constraint.Builder()
                .gridx(1)
                .gridy(1)
                .fill(java.awt.GridBagConstraints.VERTICAL)
                .weightx(0)
                .weighty(1)
                .build());

        tblCardTag.setModel(service.getCardTagModel());
        tblCardTag.setColumnSelectionAllowed(false);
        tblCardTag.setRowSelectionAllowed(false);
        tblCardTag.setShowGrid(true);
        tblCardTag.getColumnModel().getColumn(1).setMaxWidth(100);
        tblCardTag.setEnabled(false);

        tblCardTag.getModel().addTableModelListener(
            event -> modelChangeActionPerformed());

        scrollPaneCardTag.setViewportView(tblCardTag);
    }

    private void modelChangeActionPerformed() {
        if (service.isFileLoaded() && !service.isRefreshing()) {

            final int row = tblCardTag.getSelectedRow();
            if (row > -1) {
                final Tag cardTag = service.getCardTagModel().getTagAt(row);

                final JTable tblCard = parent.getPanelBottom().getTblCard();

                final int[] modelRows =
                        new int[tblCard.getSelectedRows().length];

                Iter.<Integer> of(tblCard.getSelectedRows()).eachWithIndex(
                    (index, nextSelectedRow) -> {

                        modelRows[index] =
                                tblCard.convertRowIndexToModel(nextSelectedRow);

                        final Card card = service
                            .getCardModel()
                            .getCardAt(modelRows[index]);
                        if (cardTag.isChecked()) {
                            if (TagModel.UNTAGGED.equals(cardTag.getName())) {
                                card.setTags();
                            } else {
                                card.addTags(cardTag.getName());
                            }
                        } else {
                            card.removeTags(cardTag.getName());
                        }
                    });


                for (final int i : modelRows) {
                    service.getCardModel().fireTableCellUpdated(i, 2);
                }

                btnApply.setEnabled(false);
                parent.setFileDirty();
                parent.getMainMenu().enableSave();
            }
        }
    }

    private void btnApplyActionPerformed() {

        final JTable tblCard = parent.getPanelBottom().getTblCard();

        final int selectedRow = tblCard.getSelectedRow();
        final int selectedCol = tblCard.getSelectedColumn();

        if (selectedRow > -1 && selectedCol > -1) {

            final int modelRow = tblCard.convertRowIndexToModel(selectedRow);

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
            parent.getMainMenu().enableSave();
            textArea.setEditable(false);
        }

        parent.setFileDirty();
    }

    public void setTableEnabled(final boolean state) {
        tblCardTag.setEnabled(state);
        service.setRefreshing(true);
        tblCardTag.setRowSelectionInterval(0, 0);
        tblCardTag.removeRowSelectionInterval(0, 0);
        service.setRefreshing(false);
    }

    public void setApplyButtonEnabled(final boolean newState) {
        btnApply.setEnabled(newState);
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


    /** */
    void setAllEditable() {
        getTblCardTag().setEnabled(true);
        getTextArea().setEnabled(true);
        getTextArea().setEditable(true);

    }

}
