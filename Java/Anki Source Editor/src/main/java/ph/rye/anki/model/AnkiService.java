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

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import ph.rye.common.lang.StringUtil;


/**
 * @author royce
 *
 */
public class AnkiService {


    static final String TAGS_MARKER = "@Tags: ";


    private transient boolean fileLoaded;
    private transient boolean refreshing;


    private final transient TagModel tagModel = new TagModel();
    private final transient CardModel cardModel = new CardModel();
    private final transient TagModel cardTagModel = new TagModel() {

        /** */
        private static final long serialVersionUID = 2465948892635976042L;

        /* (non-Javadoc)
         * @see ph.rye.anki.model.TagModel#setValueAt(java.lang.Object, int, int)
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

            super.setValueAt(aValue, rowIndex, columnIndex);
        }
    };

    private transient File file;

    public void openFile(final File file) throws FileNotFoundException {
        this.file = file;

        fileLoaded = false;
        cardModel.reset();
        tagModel.reset(true);
        cardTagModel.reset(false);

        new SourceReader(new FileReader(file))
            .readSource(card -> registerCard(card));

        fileLoaded = true;

    }

    private void registerCard(final Card newCard) {

        cardModel.addCard(newCard);

        for (final String tag : newCard.getTags()) {
            final Tag tagOn = new Tag(tag, true);
            final Tag tagOff = new Tag(tag, false);
            tagModel.addTag(tagOn);
            cardTagModel.addTag(tagOff);
        }
    }


    /**
     * @return the fileLoaded
     */
    public boolean isFileLoaded() {
        return fileLoaded;
    }

    /**
     * @param fileLoaded the fileLoaded to set
     */
    public void setFileLoaded(final boolean fileLoaded) {
        this.fileLoaded = fileLoaded;
    }

    /**
     * @return the tagModel
     */
    public TagModel getTagModel() {
        return tagModel;
    }

    /**
     * @return the cardModel
     */
    public CardModel getCardModel() {
        return cardModel;
    }

    /**
     * @return the cardTagModel
     */
    public TagModel getCardTagModel() {
        return cardTagModel;
    }

    /**
     * @param valueAt
     */
    public void initCardTagFromTag(final String valueAt) {
        cardTagModel.initWithTags(StringUtil.trimArray(valueAt.split(",")));
    }

    /** */
    public void updateCardTable(final int row, final int col) {
        final Card card = cardModel.getCardAt(row);
        card.setTags(cardTagModel.getSelectedTags());
        showTags(cardTagModel.getSelectedTags());

        tagModel.fireTableDataChanged();
        cardModel.fireTableCellUpdated(row, col);
    }

    private void showTags(final String... tags) {
        tagModel.untickTags(tags);
    }

    /**
     * @return
     */
    public boolean isRefreshing() {
        return refreshing;
    }

    /**
     * @param b
     */
    public void setRefreshing(final boolean state) {
        refreshing = state;
    }

    /**
     * @throws IOException
     */
    public void saveToFile(final File file) throws IOException {

        final FileWriter fileWriter = new FileWriter(
            file == null ? this.file.getAbsolutePath()
                    : file.getAbsolutePath());

        final BufferedWriter buffWriter = new BufferedWriter(fileWriter);

        for (int i = 0; i < cardModel.getRowCount(); i++) {
            final Card card = cardModel.getCardAt(i);

            buffWriter.write(card.toSource());
            buffWriter.newLine();
            buffWriter.newLine();
        }

        buffWriter.close();

    }

}
