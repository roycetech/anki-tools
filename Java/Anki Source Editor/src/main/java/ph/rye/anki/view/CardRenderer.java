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

import java.awt.Color;
import java.awt.Component;

import javax.swing.JTable;
import javax.swing.JTextArea;
import javax.swing.table.TableCellRenderer;

/**
 * @author royce
 *
 */
//public class CardRenderer extends JTextPane implements TableCellRenderer {
public class CardRenderer extends JTextArea implements TableCellRenderer {


    /** */
    private static final long serialVersionUID = -786811754824523691L;


    public CardRenderer() {
        setLineWrap(true);
        setWrapStyleWord(true);


        setEditable(false);
        setBorder(null);
    }

    @Override
    public Component getTableCellRendererComponent(final JTable table,
                                                   final Object value,
                                                   final boolean isSelected,
                                                   final boolean hasFocus,
                                                   final int row,
                                                   final int column) {

        if (isSelected) {
            setBackground(Color.decode("#39698a"));
        } else {
            if (row % 2 == 0) {
                setBackground(Color.white);
            } else {
                setBackground(Color.decode("#f2f2f2"));
            }

        }

        setText(String.valueOf(value));

        setSize(
            table.getColumnModel().getColumn(column).getWidth(),
            getPreferredSize().height + 60);

        if (table.getRowHeight(row) != getPreferredSize().height) {
            table.setRowHeight(row, getPreferredSize().height);
        }

        return this;
    }
}
