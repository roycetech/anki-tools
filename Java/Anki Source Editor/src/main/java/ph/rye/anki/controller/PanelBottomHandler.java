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
package ph.rye.anki.controller;

import javax.swing.JTable;
import javax.swing.table.TableColumn;

/**
 * @author royce
 *
 */
public class PanelBottomHandler {

    public void rdoShowFrontActionPerformed(final JTable tblCard) {
        shrinkColumnSize(tblCard.getColumnModel().getColumn(1));
        restoreColumnSize(tblCard.getColumnModel().getColumn(0));
    }

    public void rdoShowBackActionPerformed(final JTable tblCard) {
        shrinkColumnSize(tblCard.getColumnModel().getColumn(0));
        restoreColumnSize(tblCard.getColumnModel().getColumn(1));
    }


    public void rdoShowBothActionPerformed(final JTable tblCard) {
        restoreColumnSize(tblCard.getColumnModel().getColumn(0));
        restoreColumnSize(tblCard.getColumnModel().getColumn(1));
    }


    /** */
    public void restoreColumnSize(final TableColumn column) {
        column.setPreferredWidth(75);
        column.setMinWidth(15);
        column.setMaxWidth(Integer.MAX_VALUE);
    }

    /**
     * Hide column.
     *
     * @param column column to hide.
     */
    public void shrinkColumnSize(final TableColumn column) {
        column.setPreferredWidth(0);
        column.setMinWidth(0);
        column.setMaxWidth(0);
    }

}
