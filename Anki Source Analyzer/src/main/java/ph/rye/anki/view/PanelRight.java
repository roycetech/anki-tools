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
import java.awt.event.ActionEvent;

import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.ListSelectionModel;

import ph.rye.anki.AnkiMainGui;
import ph.rye.anki.model.AnkiService;
import ph.rye.anki.model.Tag;
import ph.rye.anki.model.TagModel;
import ph.rye.common.lang.StringUtil;

/**
 * @author royce
 */
public class PanelRight extends JPanel {


    /** */
    private static final long serialVersionUID = 1L;


    @SuppressWarnings({
            "PMD.UnusedPrivateField",
            "PMD.SingularField" })
    private transient final AnkiMainGui parent;

    private final transient AnkiService service;

    private final transient JScrollPane scrollPaneTag = new JScrollPane();

    private final transient JPanel panelCheckBox = new JPanel();
    private final transient JButton btnInverse = new JButton();
    //    private final transient JToggleButton btnAny = new JToggleButton("Any");


    private final transient JCheckBox chkCheckAll = new JCheckBox();

    private final transient JTable tblTag = new JTable();

    private final transient JPanel panelButton = new JPanel();
    private final transient JButton btnAddTag = new JButton();
    private final transient JButton btnDeleteTag = new JButton();


    public PanelRight(final AnkiMainGui parent, final AnkiService service) {
        this.parent = parent;
        this.service = service;
    }

    public void initComponents() {
        setMaximumSize(new Dimension(Integer.MAX_VALUE, 218));
        setMinimumSize(new Dimension(300, 106));
        setLayout(new GridBagLayout());

        chkCheckAll.setSelected(true);
        chkCheckAll.setText("Check All");
        chkCheckAll.addActionListener(evt -> chkCheckAllActionPerformed(evt));
        panelCheckBox.add(chkCheckAll);

        btnInverse.setText("Inverse");
        btnInverse.addActionListener(evt -> btnInverseActionPerformed());
        panelCheckBox.add(btnInverse);

        add(
            panelCheckBox,
            new Constraint.Builder()
                .gridx(0)
                .gridy(0)
                .anchor(java.awt.GridBagConstraints.SOUTH)
                .build());

        tblTag.setModel(service.getTagModel());
        tblTag.setCellSelectionEnabled(false);
        tblTag.setRowSelectionAllowed(true);
        tblTag.getColumnModel().getColumn(1).setMaxWidth(70);

        tblTag.getModel().addTableModelListener(p -> {

            if (service.isFileLoaded()) {
                if (!service.isRefreshing()) {
                    parent.getPanelBottom().filterCards();
                }
                parent.getPanelBottom().selectFirstRow();
            }

        });

        final ListSelectionModel tagSelectModel = tblTag.getSelectionModel();
        tagSelectModel.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);

        tagSelectModel.addListSelectionListener(p ->

        {
            final int[] selectedRow = tblTag.getSelectedRows();
            btnDeleteTag.setEnabled(
                selectedRow.length > 0
                        && selectedRow[0] >= TagModel.FIXED_TAGS.length);
        });
        scrollPaneTag.setViewportView(tblTag);

        add(
            scrollPaneTag,
            new Constraint.Builder()
                .gridx(0)
                .gridy(1)
                .gridwidth(2)
                .fill(java.awt.GridBagConstraints.BOTH)
                .anchor(java.awt.GridBagConstraints.NORTHWEST)
                .weightx(1)
                .weighty(1)
                .build());

        btnAddTag.setText("Add");
        btnAddTag.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        btnAddTag.addActionListener(evt -> btnAddTagActionPerformed());
        panelButton.add(btnAddTag);

        btnDeleteTag.setText("Delete");
        btnDeleteTag.setEnabled(false);
        btnDeleteTag.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        btnDeleteTag.addActionListener(evt -> btnDeleteTagActionPerformed());
        panelButton.add(btnDeleteTag);

        add(panelButton, new Constraint.Builder().gridx(0).gridy(2).build());
    }

    private void btnAddTagActionPerformed() {

        final String newTagName = (String) JOptionPane.showInputDialog(
            this,
            "Tag Name",
            "Add New Tag",
            JOptionPane.PLAIN_MESSAGE,
            null,
            null,
            null);

        if (StringUtil.hasValue(newTagName)) {

            service.getTagModel().addTag(new Tag(newTagName, true));
            service.getCardTagModel().addTag(new Tag(newTagName, false));
        }

    }

    private void btnDeleteTagActionPerformed() {
        final String tagToDelete = service
            .getTagModel()
            .getTagAt(tblTag.getSelectedRow())
            .getName();
        service.getTagModel().deleteTag(tagToDelete);
        service.getCardModel().deleteTag(tagToDelete);
    }


    private void chkCheckAllActionPerformed(final ActionEvent event) {
        for (int i = 0; i < service.getTagModel().getRowCount(); i++) {
            final JCheckBox checkBox = (JCheckBox) event.getSource();
            service.getTagModel().setValueAt(checkBox.isSelected(), i, 1);
        }
    }

    private void btnInverseActionPerformed() {
        for (int i = 0; i < service.getTagModel().getRowCount(); i++) {
            service.getTagModel().setValueAt(
                !(Boolean) service.getTagModel().getValueAt(i, 1),
                i,
                1);
        }
    }

}
