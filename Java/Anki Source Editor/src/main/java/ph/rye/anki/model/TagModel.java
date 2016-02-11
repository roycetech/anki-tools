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
package ph.rye.anki.model;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.swing.table.AbstractTableModel;

import ph.rye.anki.util.Ano;
import ph.rye.anki.util.Range;

/**
 * @author royce
 */
public class TagModel extends AbstractTableModel {


    /** */
    private static final long serialVersionUID = 1L;


    //    private final transient List<Tag> tagList = new ArrayList<>();
    private final transient Map<String, Tag> tagMap = new LinkedHashMap<>();

    public static final String UNTAGGED = "<untagged>";

    public static final String[] FIXED_TAGS = {
            "High",
            "FB Only",
            "BF Only",
            "Enum",
            "Low",
            "Ignore",
            UNTAGGED };


    private static final String[] COL_NAMES = new String[] {
            "Tag",
            "Show" };


    public TagModel() {
        initFixedTags();
    }


    @SuppressWarnings("PMD.AvoidInstantiatingObjectsInLoops")
    private final void initFixedTags(final boolean state) {
        for (final String fixedTag : FIXED_TAGS) {
            tagMap.put(fixedTag, new Tag(fixedTag, state));
        }
    }

    private final void initFixedTags() {
        initFixedTags(true);
    }


    /* (non-Javadoc)
     * @see javax.swing.table.AbstractTableModel#getColumnName(int)
     */
    @Override
    public String getColumnName(final int column) {
        return COL_NAMES[column];
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
        //return allTagNames.size();
        return tagMap.size();
    }

    /* (non-Javadoc)
     * @see javax.swing.table.TableModel#getColumnCount()
     */
    @Override
    public int getColumnCount() {
        return 2;
    }

    public void addTag(final Tag tag) {
        if (!tagMap.keySet().contains(tag.getName())) {
            tagMap.put(tag.getName(), tag);
            super.fireTableRowsInserted(tagMap.size() - 1, tagMap.size() - 1);
        }
    }

    /* (non-Javadoc)
     * @see javax.swing.table.TableModel#getValueAt(int, int)
     */
    @Override
    public Object getValueAt(final int rowIndex, final int columnIndex) {

        final Ano<Object> retval = new Ano<Object>();
        if (columnIndex == 0) {
            final Tag tag = getTagAt(rowIndex);
            retval.set(tag.getName());
        } else if (columnIndex == 1) {
            final Tag tag = getTagAt(rowIndex);
            retval.set(tag.isChecked());
        }

        return retval.get();
    }

    /* (non-Javadoc)
     * @see javax.swing.table.AbstractTableModel#setValueAt(java.lang.Object, int, int)
     */
    @Override
    public void setValueAt(final Object aValue, final int rowIndex,
                           final int columnIndex) {


        final List<String> keyList = new ArrayList<>(tagMap.keySet());
        final Tag tag = tagMap.get(keyList.get(rowIndex));

        if (UNTAGGED.equals(tag.getName())) {
            this.initWithTags(UNTAGGED);
        } else {
            this.untickTags(UNTAGGED);
        }

        tag.setChecked((boolean) aValue);
        super.fireTableCellUpdated(FIXED_TAGS.length - 1, columnIndex);
        super.fireTableCellUpdated(rowIndex, columnIndex);

    }

    /**
     * @param rowIndex
     * @return
     */
    public Tag getTagAt(final int rowIndex) {
        final List<String> keyList = new ArrayList<>(tagMap.keySet());
        return tagMap.get(keyList.get(rowIndex));
    }

    @Override
    public boolean isCellEditable(final int row, final int column) {
        return true;
    }

    public boolean isTagEnabled(final String tag) {
        if (tagMap.get(tag) == null) {
            return false;
        } else {
            return tagMap.get(tag).isChecked();
        }

    }

    public void initWithTags(final String... tags) {

        final List<String> keyList = new ArrayList<>(tagMap.keySet());
        new Range<Integer>(0, tagMap.size()).each((i) -> {
            final Tag nextTag = tagMap.get(keyList.get(i));
            nextTag.setChecked(Arrays.asList(tags).contains(nextTag.getName()));
            fireTableCellUpdated(i, 1);
        });
    }

    public String[] getSelectedTags() {
        final List<String> retval = new ArrayList<>();
        for (final Tag nextTag : tagMap.values()) {
            if (nextTag.isChecked()) {
                retval.add(nextTag.getName());
            }
        }
        return retval.toArray(new String[retval.size()]);
    }

    /** */
    public void reset(final boolean state) {
        tagMap.clear();
        initFixedTags(state);
        super.fireTableDataChanged();
    }

    public void untickTags(final String... tags) {
        for (final String string : tags) {
            final Tag tag = tagMap.get(string);
            tag.setChecked(false);
        }
    }

    public void tickTags(final String... tags) {
        for (final String string : tags) {
            final Tag tag = tagMap.get(string);
            tag.setChecked(true);
        }

    }

}
