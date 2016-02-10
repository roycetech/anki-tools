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

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.swing.table.AbstractTableModel;

/**
 * @author royce
 *
 */
public class TagModel extends AbstractTableModel {


    /** */
    private static final long serialVersionUID = 1L;


    private final List<Tag> tagList = new ArrayList<>();

    public static final String[] FIXED_TAGS = {
            "<untagged>",
            "High",
            "Low",
            "Enum",
            "BF Only",
            "FB Only",
            "Ignore" };

    private final Set<String> allTags =
            new HashSet<>(Arrays.asList(FIXED_TAGS));


    public TagModel() {

        for (final String fixedTag : FIXED_TAGS) {
            tagList.add(new Tag(fixedTag, true));
        }

    }

    private final String[] columnNames = new String[] {
            "Tag",
            "Show" };

    /* (non-Javadoc)
     * @see javax.swing.table.AbstractTableModel#getColumnName(int)
     */
    @Override
    public String getColumnName(final int column) {
        return columnNames[column];
    }

    @Override
    public Class<?> getColumnClass(final int column) {
        return getValueAt(0, column).getClass();
    }


    /* (non-Javadoc)
     * @see javax.swing.table.TableModel#getRowCount()
     */
    @Override
    public int getRowCount() {
        return tagList.size();
    }

    /* (non-Javadoc)
     * @see javax.swing.table.TableModel#getColumnCount()
     */
    @Override
    public int getColumnCount() {
        return 2;
    }

    public void addTag(final Tag tag) {
        if (!allTags.contains(tag.getName())) {
            tagList.add(tag);
            allTags.add(tag.getName());
            super.fireTableRowsInserted(tagList.size() - 1, tagList.size() - 1);
        }
    }

    /* (non-Javadoc)
     * @see javax.swing.table.TableModel#getValueAt(int, int)
     */
    @Override
    public Object getValueAt(final int rowIndex, final int columnIndex) {
        final Tag tag = getTagAt(rowIndex);

        Object retval = null;
        switch (columnIndex) {
            case 0:
                retval = tag.getName();
                break;
            case 1:
                retval = tag.isShow();
                break;
        }
        return retval;
    }

    /* (non-Javadoc)
     * @see javax.swing.table.AbstractTableModel#setValueAt(java.lang.Object, int, int)
     */
    @Override
    public void setValueAt(final Object aValue, final int rowIndex,
                           final int columnIndex) {
        final Tag tag = tagList.get(rowIndex);
        tag.setShow((boolean) aValue);
        super.fireTableCellUpdated(rowIndex, columnIndex);

    }

    /**
     * @param rowIndex
     * @return
     */
    public Tag getTagAt(final int rowIndex) {
        return tagList.get(rowIndex);
    }

    @Override
    public boolean isCellEditable(final int row, final int column) {
        return true;
    }

    public boolean isTagEnabled(final String tag) {
        final Ano<Boolean> ano = new Ano<>(false);

        for (final Tag nextTag : tagList) {
            if (nextTag.isShow() && nextTag.getName().equals(tag)) {
                ano.set(true);
                break;
            }
        }
        return ano.get();
    }

}
