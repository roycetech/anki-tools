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

import ph.rye.common.lang.Ano;
import ph.rye.common.loop.Iter;
import ph.rye.common.loop.Range;

/**
 * @author royce
 */
public class TagModel extends AbstractTableModel {


    /** */
    private static final long serialVersionUID = 1L;


    protected final transient Map<String, Tag> tagMap = new LinkedHashMap<>();

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
            "Show",
            "Count" };


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


    /** {@inheritDoc} */
    @Override
    public String getColumnName(final int column) {
        return COL_NAMES[column];
    }

    @Override
    public Class<?> getColumnClass(final int column) {
        return getValueAt(0, column).getClass();
    }


    /** {@inheritDoc} */
    @Override
    public int getRowCount() {
        return tagMap.size();
    }

    /** {@inheritDoc} */
    @Override
    public int getColumnCount() {
        return COL_NAMES.length;
    }

    public void addTag(final Tag tag) {

        if (tagMap.containsKey(tag.getName())) {
            final Tag oldTag = tagMap.get(tag.getName());
            oldTag.incrementCount();
        } else {
            tag.incrementCount();
            tagMap.put(tag.getName(), tag);
            super.fireTableRowsInserted(tagMap.size() - 1, tagMap.size() - 1);
        }
    }

    /** {@inheritDoc} */
    @Override
    public Object getValueAt(final int rowIndex, final int columnIndex) {

        final Ano<Object> retval = new Ano<Object>();
        if (columnIndex == 0) {
            final Tag tag = getTagAt(rowIndex);
            retval.set(tag.getName());
        } else if (columnIndex == 1) {
            final Tag tag = getTagAt(rowIndex);
            retval.set(tag.isChecked());
        } else if (columnIndex == 2) {
            final Tag tag = getTagAt(rowIndex);
            retval.set(tag.getCount());
        }

        return retval.get();
    }

    /** {@inheritDoc} */
    @Override
    public void setValueAt(final Object aValue, final int rowIndex,
                           final int columnIndex) {

        final List<String> keyList = new ArrayList<>(tagMap.keySet());
        final Tag tag = tagMap.get(keyList.get(rowIndex));


        tag.setChecked((boolean) aValue);
        super.fireTableCellUpdated(FIXED_TAGS.length - 1, 1);
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

    void initWithTags(final String... tags) {
        final List<String> tagList = new ArrayList<>();
        if (tags.length > 0 && "".equals(tags[0])) {
            tagList.add(UNTAGGED);
        } else {
            tagList.addAll(Arrays.asList(tags));
        }

        final List<String> keyList = new ArrayList<>(tagMap.keySet());
        new Range<Integer>(0, tagMap.size() - 1).each((i, next) -> {
            final Tag nextTag = tagMap.get(keyList.get(i));
            nextTag.setChecked(!tagList.contains(nextTag.getName()));
            nextTag.setChecked(!nextTag.isChecked());
        });
        fireTableDataChanged();
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
    void reset(final boolean state) {
        tagMap.clear();
        initFixedTags(state);
        super.fireTableDataChanged();
    }

    void untickTags(final String... tags) {

        Iter.string(tags).each((index, nextElement) -> {
            final Tag tag = tagMap.get(nextElement);
            tag.setChecked(false);
            fireTableCellUpdated(index, 1);
        });
    }


    public void deleteTag(final String... tags) {
        Iter.string(tags).each((index, nextElement) -> {
            tagMap.remove(nextElement);
            fireTableRowsDeleted(index, index);
        });
    }

}
