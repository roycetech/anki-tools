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

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import ph.rye.anki.AnkiMainGui;
import ph.rye.anki.util.AbstractBuffReader;
import ph.rye.anki.util.Ano;
import ph.rye.anki.util.Counter;
import ph.rye.anki.util.StringUtil;

/**
 * @author royce
 *
 */
public class AnkiService {


    public static final String TAGS_MARKER = "@Tags: ";


    private transient boolean fileLoaded;
    private transient boolean refreshing;


    private final transient TagModel tagModel = new TagModel();
    private final transient CardModel cardModel = new CardModel();
    private final transient TagModel cardTagModel = new TagModel();

    private transient File file;

    public void openFile(final File file) {
        this.file = file;

        fileLoaded = false;
        cardModel.reset();
        tagModel.reset(true);
        cardTagModel.reset(false);

        try (final BufferedReader buffReader =
                new BufferedReader(new FileReader(file))) {

            final Counter spaceCounter = new Counter(0);

            new AbstractBuffReader<Object>(
                buffReader,
                Object.class,
                new ArrayList<String>(),
                new ArrayList<String>(),
                new ArrayList<String>(),
                new Ano<Boolean>(false)) {

                @SuppressWarnings("unchecked")
                @Override
                public void next(final String line) {

                    if ("".equals(line.trim())) {
                        spaceCounter.inc();
                    } else {

                        final Ano<Boolean> isAnswer = (Ano<Boolean>) get(3);

                        if (spaceCounter.get() >= 2) {
                            final List<String> front = (List<String>) get(0);
                            final List<String> back = (List<String>) get(1);
                            final List<String> tags = (List<String>) get(2);

                            isAnswer.set(false);

                            registerCard(front, back, tags);

                            front.clear();
                            back.clear();
                            tags.clear();
                        } else if (spaceCounter.get() == 1) {
                            isAnswer.set(true);
                        }

                        if (isAnswer.get()) {
                            final List<String> back = (List<String>) get(1);
                            back.add(line);

                        } else {

                            if (line.startsWith(TAGS_MARKER)) {
                                final List<String> tags = (List<String>) get(2);
                                tags
                                    .addAll(
                                        Arrays
                                            .asList(
                                                StringUtil
                                                    .trimArray(
                                                        line
                                                            .substring(
                                                                TAGS_MARKER
                                                                    .length())
                                                            .split(","))));
                            } else {
                                final List<String> front =
                                        (List<String>) get(0);
                                front.add(StringUtil.rtrim(line));
                            }

                        }

                        spaceCounter.reset();
                    }

                }
            }.eachLine();

        } catch (final IOException ex) {
            Logger.getLogger(AnkiMainGui.class.getName()).log(
                Level.SEVERE,
                null,
                ex);
        }
        fileLoaded = true;

    }

    @SuppressWarnings("PMD.AvoidInstantiatingObjectsInLoops")
    public void registerCard(final List<String> front, final List<String> back,
                             final List<String> tags) {

        final Card newCard = new Card(
            StringUtil.join(front, "\n"),
            StringUtil.join(back, "\n"));

        newCard.addTags(tags.toArray(new String[tags.size()]));

        cardModel.addCard(newCard);

        for (final String tag : tags) {
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

    public void hideTag(final String... tags) {
        tagModel.tickTags(tags);
    }

    public void showTags(final String... tags) {
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
    public void saveToFile() throws IOException {
        final FileWriter fileWriter = new FileWriter(file.getAbsoluteFile());
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
