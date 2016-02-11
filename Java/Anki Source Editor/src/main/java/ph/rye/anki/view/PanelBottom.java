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

import javax.swing.ButtonGroup;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.ListSelectionModel;
import javax.swing.RowFilter;
import javax.swing.event.ListSelectionListener;
import javax.swing.table.TableColumn;
import javax.swing.table.TableRowSorter;

import ph.rye.anki.AnkiMainGui;
import ph.rye.anki.model.AnkiService;
import ph.rye.anki.model.CardModel;
import ph.rye.anki.util.Ano;
import ph.rye.anki.util.StringUtil;

/**
 * @author royce
 *
 */
public class PanelBottom extends JPanel {


    /** */
    private static final long serialVersionUID = 172157402700377123L;

    @SuppressWarnings({
            "PMD.UnusedPrivateField",
            "PMD.SingularField" })
    private transient final AnkiMainGui parent;

    private final transient AnkiService service;


    private transient TableRowSorter<CardModel> cardRowSorter;


    private final transient JPanel panelRadio = new JPanel();
    private final transient ButtonGroup rdoGrpToggleCol = new ButtonGroup();
    private final transient JRadioButton rdoShowBack = new JRadioButton();
    private final transient JRadioButton rdoShowBoth = new JRadioButton();
    private final transient JRadioButton rdoShowFront = new JRadioButton();
    private final transient JScrollPane scrollPaneCard = new JScrollPane();
    private final transient JTable tblCard = new JTable();
    private final transient JLabel lblCard = new JLabel();


    public PanelBottom(final AnkiMainGui parent, final AnkiService service) {
        this.parent = parent;
        this.service = service;
    }


    public void initComponents() {
        setLayout(new java.awt.GridBagLayout());

        rdoGrpToggleCol.add(rdoShowBoth);
        rdoShowBoth.setSelected(true);
        rdoShowBoth.setText("Show Both");
        rdoShowBoth.addActionListener(evt -> rdoShowBothActionPerformed());
        panelRadio.add(rdoShowBoth);

        rdoGrpToggleCol.add(rdoShowFront);
        rdoShowFront.setText("Front Only");
        rdoShowFront.addActionListener(evt -> rdoShowFrontActionPerformed());
        panelRadio.add(rdoShowFront);

        rdoGrpToggleCol.add(rdoShowBack);
        rdoShowBack.setText("Back Only");
        rdoShowBack.addActionListener(evt -> rdoShowBackActionPerformed());
        panelRadio.add(rdoShowBack);

        add(
            panelRadio,
            new Constraint.Builder()
                .gridx(0)
                .gridy(0)
                .anchor(java.awt.GridBagConstraints.WEST)
                .build());

        tblCard.setModel(service.getCardModel());

        tblCard.setColumnSelectionAllowed(true);
        tblCard.setRowSelectionAllowed(true);

        cardRowSorter = new TableRowSorter<>(service.getCardModel());
        tblCard.setRowSorter(cardRowSorter);

        final ListSelectionModel colSelectionModel =
                tblCard.getColumnModel().getSelectionModel();


        final ListSelectionModel rowSelectionModel =
                tblCard.getSelectionModel();

        tblCard.setShowGrid(true);

        final ListSelectionListener cellChangeListener = event -> {

            final int selectedRow = tblCard.getSelectedRow();
            final int selectedColumn = tblCard.getSelectedColumn();

            if (selectedRow < 0) {
                return;
            }

            final PanelLeft panelLeft = parent.getPanelLeft();

            if (selectedColumn < 2) {

                panelLeft.getTextArea().setText(
                    (String) tblCard.getValueAt(selectedRow, selectedColumn));

                panelLeft.getScrollPaneCardTag().setVisible(false);
                panelLeft.getScrollPaneText().setVisible(true);

            } else {

                panelLeft.getTextArea().setText("");
                panelLeft.getScrollPaneCardTag().setVisible(true);
                panelLeft.getScrollPaneText().setVisible(false);
            }

            panelLeft.getTextArea().setEditable(selectedColumn < 2);
            panelLeft.getBtnApply().setEnabled(true);
        };


        colSelectionModel.addListSelectionListener(cellChangeListener);
        rowSelectionModel.addListSelectionListener(cellChangeListener);
        rowSelectionModel.addListSelectionListener(e -> {
            final int selectedRow = tblCard.getSelectedRow();
            if (selectedRow > -1) {
                service.initCardTagFromTag(
                    (String) tblCard.getValueAt(selectedRow, 2));
            }

        });

        scrollPaneCard.setViewportView(tblCard);

        tblCard.getColumnModel().getSelectionModel().setSelectionMode(
            ListSelectionModel.SINGLE_SELECTION);
        tblCard.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);

        add(
            scrollPaneCard,
            new Constraint.Builder()
                .gridx(0)
                .gridy(1)
                .fill(java.awt.GridBagConstraints.BOTH)
                .weightx(1)
                .weighty(1)
                .build());

        lblCard.setText("No cards found.");
        lblCard.setToolTipText("");

        add(
            lblCard,
            new Constraint.Builder()
                .gridx(0)
                .gridy(2)
                .fill(java.awt.GridBagConstraints.HORIZONTAL)
                .build());


    }

    private void rdoShowFrontActionPerformed() {
        shrinkColumnSize(tblCard.getColumnModel().getColumn(1));
        restoreColumnSize(tblCard.getColumnModel().getColumn(0));
    }

    private void rdoShowBackActionPerformed() {
        shrinkColumnSize(tblCard.getColumnModel().getColumn(0));
        restoreColumnSize(tblCard.getColumnModel().getColumn(1));
    }


    private void rdoShowBothActionPerformed() {
        restoreColumnSize(tblCard.getColumnModel().getColumn(0));
        restoreColumnSize(tblCard.getColumnModel().getColumn(1));
    }


    /** */
    void restoreColumnSize(final TableColumn column) {
        column.setPreferredWidth(75);
        column.setMinWidth(15);
        column.setMaxWidth(Integer.MAX_VALUE);
    }

    /**
     * Hide column.
     *
     * @param column column to hide.
     */
    void shrinkColumnSize(final TableColumn column) {
        column.setPreferredWidth(0);
        column.setMinWidth(0);
        column.setMaxWidth(0);
    }


    public void filterCards() {

        cardRowSorter.setRowFilter(new RowFilter<CardModel, Object>() {

            @Override
            public boolean include(final RowFilter.Entry<? extends CardModel, ? extends Object> entry) {

                final String tagStr = (String) entry.getValue(2);
                String[] tagArr;
                if ("".equals(tagStr)) {
                    tagArr = new String[] {
                            "<untagged>" };
                } else {
                    tagArr = StringUtil.trimArray(tagStr.split(","));
                }

                final Ano<Boolean> retval = new Ano<>(false);
                for (final String tag : tagArr) {
                    if (service.getTagModel().isTagEnabled(tag)) {
                        retval.set(true);
                        break;
                    }
                }
                return retval.get();
            }


        });

        refreshLabelText();
    }


    /**
     * @return the tblCard
     */
    public JTable getTblCard() {
        return tblCard;
    }


    /**
     * @return the lblCard
     */
    public JLabel getLblCard() {
        return lblCard;
    }


    /**
     *
     */
    public void refreshLabelText() {
        getLblCard()
            .setText(String.format("Total card(s): %d", tblCard.getRowCount()));
    }

}
